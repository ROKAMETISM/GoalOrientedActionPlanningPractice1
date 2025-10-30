class_name GOAPAgent
extends Node
var _goals : Array[Goal]
var _actions : Array[Action]
var _world_state := WorldState.new()
var _planner := GOAPPlanner.new()
var _current_goal : Goal
var _current_plan : Array[Action]
var _current_plan_step = 0

var _actor

func _init() -> void:
	_planner.set_actions(_actions)
	add_child(_world_state)
	add_child(_planner)

func _physics_process(delta):
	var goal = _get_best_goal()
	if not goal:
		return
	if _current_goal == null or goal != _current_goal:
	# You can set in the blackboard any relevant information you want to use
	# when calculating action costs and status. I'm not sure here is the best
	# place to leave it, but I kept here to keep things simple.
		var blackboard = {
			#"position": _actor.position,
			}

		for s in _world_state._state:
			blackboard[s] = _world_state._state[s]
		_current_goal = goal
		_current_plan = GOAPPlanner.new().get_plan(_current_goal, blackboard)
		_current_plan_step = 0
	else:
		_follow_plan(_current_plan, delta)
	

func init(actor, goals: Array[Goal]):
	_actor = actor
	_goals = goals


#
# Returns the highest priority goal available.
#
func _get_best_goal():
	var highest_priority = null

	for goal in _goals:
		if goal.is_valid() and (highest_priority == null or goal.priority() > highest_priority.priority()):
			highest_priority = goal

	return highest_priority


#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan, delta):
	if plan.size() == 0:
		return
	var is_step_complete = plan[_current_plan_step].perform(_actor, delta)
	if is_step_complete and _current_plan_step < plan.size() - 1:
		_current_plan_step += 1
