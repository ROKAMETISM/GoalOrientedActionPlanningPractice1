class_name GOAPPlanner extends Node

var _actions: Array[Action]

func set_actions(actions: Array[Action])->void:
	_actions = actions


func get_plan(goal: Goal, local_world : LocalWorld)->Plan:
	var plan  = Plan.new()
	var desired_state : Dictionary = goal.get_desired_state().duplicate()
	if desired_state.is_empty():
		return plan
	return _find_best_plan(desired_state, local_world)


func _find_best_plan(desired_state : Dictionary, local_world : LocalWorld)->Plan:
  # goal is set as root action. It does feel weird
  # but the code is simpler this way.
	var root := PlanNode.new()
	root.set_node(null, desired_state)

  # build plans will populate root with children.
  # In case it doesn't find a valid path, it will return false.
	if _build_plan_tree(root, local_world):
		root.print_tree()
		var plans = _transform_tree_into_array(root, local_world)
		return _get_cheapest_plan(plans)
	return Plan.new()


#
# Compares plan's cost and returns
# actions included in the cheapest one.
#
func _get_cheapest_plan(plans)->Plan:
	var best_plan : Plan = null
	for plan in plans:
		_print_plan(plan)
		if best_plan == null or plan.cost < best_plan.cost:
			best_plan = plan
	return best_plan


#
# Builds graph with actions. Only includes valid plans (plans
# that achieve the goal).
#
# Returns true if the path has a solution.
#
# This function uses recursion to build the graph. This is
# necessary because any new action included in the graph may
# add pre-conditions to the desired state that can be satisfied
# by previously considered actions, meaning, on every step we
# need to iterate from the beginning to find all solutions.
#
# Be aware that for simplicity, the current implementation is not protected from
# circular dependencies. This is easy to implement though.
#
func _build_plan_tree(root : PlanNode, local_world : LocalWorld)->bool:
	var has_followup = false
	# each node in the graph has it's own desired state.
	var state : Dictionary = root.duplicate_desired_state()
	# checks if the local_world contains data that can
	# satisfy the current state.
	_erase_matching_state(state, local_world.get_states())

  # if the state is empty, it means this branch already
  # found the solution, so it doesn't need to look for
  # more actions
	if state.is_empty():
		return true

	for action in _actions:
		if not action.is_valid():
			continue

		var should_use_action = false
		var effects = action.get_effects()
		var desired_state : Dictionary = state.duplicate()
	
		# check if action should be used, i.e. it
		# satisfies at least one condition from the
		# desired state
		should_use_action = _erase_matching_state(desired_state, effects)
		if not should_use_action:
			continue
		# adds actions pre-conditions to the desired state
		var preconditions = action.get_preconditions()
		desired_state.merge(preconditions)
		var child_node := PlanNode.new()
		child_node.set_node(action, desired_state)
		# if desired state is empty, it means this action
		# can be included in the graph.
		# if it's not empty, _build_plan_tree is called again (recursively) so
		# it can try to find actions to satisfy this current state. In case
		# it can't find anything, this action won't be included in the graph.
		if desired_state.is_empty() or _build_plan_tree(child_node, local_world):
			root.add_child_node(child_node)
			has_followup = true

	return has_followup


func _erase_matching_state(state_to_erase:Dictionary, state_reference:Dictionary)->bool:
	var has_erased := false
	for state_name in state_to_erase:
		if state_to_erase[state_name] == state_reference.get(state_name):
			state_to_erase.erase(state_name)
			has_erased = true
	return has_erased

#
# Transforms graph with actions into list of actions and calculates
# the cost by summing actions' cost
#
# Returns list of plans.
#
func _transform_tree_into_array(root:PlanNode, local_world : LocalWorld) -> Array[Plan]:
	var plans : Array[Plan] = []
	var action : Action = root.get_action()
	if root.get_children().size() == 0:
		var plan = Plan.new() 
		if action:
			plan.init([action], [action.get_cost(local_world._state)])
		plans.append(plan)
		return plans
	var child_nodes := root.get_children()
	for node : PlanNode in child_nodes:
		var sub_plans : Array[Plan] = _transform_tree_into_array(node, local_world)
		for child_plan in sub_plans:
			plans.append(child_plan)
			if action == null:
				continue
			if action.has_method("get_cost"):
				child_plan.append(action, action.get_cost(local_world._state))
	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan:Plan)->void:
	var action_names : Array[String] = []
	for action : Action in plan.get_actions():
		action_names.append(action.action_name())
	Fn.LOG({"cost": plan.get_cost(), "actions": action_names})

class PlanNode:
	var _action : Action = null
	var _desired_state : Dictionary = {}
	var _children : Array[PlanNode] = []
	func set_node(action:Action, desired_state:Dictionary)->void:
		_action = action
		_desired_state = desired_state
	func get_action()->Action:
		return _action
	func get_desired_state()->Dictionary:
		return _desired_state
	func duplicate_desired_state()->Dictionary:
		return _desired_state.duplicate()
	func get_children()->Array[PlanNode]:
		return _children
	func state(key):
		return _desired_state[key]
	func add_child_node(node:PlanNode)->void:
		_children.append(node)
	func print_tree(index:int=0)->int:
		if _action:
			print("Node#%d [%d]:%s"%[index,  _children.size(), _action.action_name(),])
		else:
			print()
			Fn.LOG("PlanTree")
			print("Node#%d [%d]:no_action"%[index, _children.size() ])
		for child_node in _children:
			index = child_node.print_tree(index+1)
		return index
