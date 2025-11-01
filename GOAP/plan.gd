class_name Plan extends Node
var _actions : Array[Action] = []
var _cost : int = 0
var _current_step := 0

func is_empty() -> bool:
	return _actions.is_empty()
func get_current_action() -> Action:
	return _actions[_current_step]
func get_action(index : int)->Action:
	return _actions[index]
func get_actions()->Array[Action]:
	return _actions
func get_cost()->int:
	return _cost
func append(action:Action, cost:int)->void:
	_actions.append(action)
	_cost += cost
func init(actions:Array[Action], costs:Array[int])->void:
	for i in range(actions.size()):
		_actions.append(actions[i])
		_cost += costs[i]
	_current_step = 0

#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
#func _follow_plan(plan, delta):
#	if plan.size() == 0:
#		return
#	var is_step_complete = plan[_current_plan_step].perform(_actor, delta, _world_state)
#	if is_step_complete and _current_plan_step < plan.size() - 1:
#		_current_plan_step += 1

func follow_plan(_actor, delta, world_state):
	if _actions.size() == 0:
		return
	var is_step_complete = _actions[_current_step].perform(_actor, delta, world_state)
	if is_step_complete and (_current_step < _actions.size() - 1):
		_current_step += 1
