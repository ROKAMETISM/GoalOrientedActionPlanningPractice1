class_name GOAPPlanner extends Node

var _actions: Array[Action]
func set_actions(actions: Array[Action])->void:
	_actions = actions
func get_plan(goal: Goal, world_state : WorldState)->Array[Action]:
	var desired_state : Dictionary = goal.get_desired_state().duplicate()
	if desired_state.is_empty():
		return []
	return _find_best_plan(goal, desired_state, world_state)
func _find_best_plan(goal : Goal, desired_state : Dictionary, world_state : WorldState)->Array[Action]:
  # goal is set as root action. It does feel weird
  # but the code is simpler this way.
	var root := PlanNode.new()
	root.set_node(null, desired_state)

  # build plans will populate root with children.
  # In case it doesn't find a valid path, it will return false.
	if _build_plans(root, world_state):
		var plans = _transform_tree_into_array(root, world_state)
		return _get_cheapest_plan(plans)
	return []


#
# Compares plan's cost and returns
# actions included in the cheapest one.
#
func _get_cheapest_plan(plans)->Array[Action]:
	var best_plan = null
	for p in plans:
		_print_plan(p)
		if best_plan == null or p.cost < best_plan.cost:
			best_plan = p
	var return_plan : Array[Action]
	if best_plan :
		for best_action in best_plan.actions:
			return_plan.append(best_action)
	return return_plan


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
func _build_plans(current_node : PlanNode, world_state : WorldState)->bool:
	var has_followup = false
	# each node in the graph has it's own desired state.
	var state : Dictionary = current_node.duplicate_desired_state()
	# checks if the world_state contains data that can
	# satisfy the current state.
	_erase_matching_state(state, world_state._state)

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
		var s := PlanNode.new()
		s.set_node(action, desired_state)
		# if desired state is empty, it means this action
		# can be included in the graph.
		# if it's not empty, _build_plans is called again (recursively) so
		# it can try to find actions to satisfy this current state. In case
		# it can't find anything, this action won't be included in the graph.
		if desired_state.is_empty() or _build_plans(s, world_state):
			current_node.add_child_node(s)
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
func _transform_tree_into_array(root:PlanNode, world_state : WorldState):
	var plans : Array[Dictionary] = []
	var action : Action = root.get_action()
	if root.get_children().size() == 0:
		action = root.get_action()
		plans.append({ "actions": [action], "cost": action.get_cost(world_state._state) })
		return plans

	for plan in root.get_children():
		for child_plan in _transform_tree_into_array(plan, world_state):
			if not action:
				continue
			if action.has_method("get_cost"):
				child_plan.actions.append(action)
				child_plan.cost += action.get_cost(world_state._state)
			plans.append(child_plan)
	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan):
	var actions = []
	for a in plan.actions:
		actions.append(a.action_name())
	Fn.LOG({"cost": plan.cost, "actions": actions})

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
