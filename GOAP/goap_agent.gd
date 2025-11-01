class_name GOAPAgent extends Node
var _goals : Array[Goal]
var _actions : Array[Action]
var _world_state := WorldState.new()
var _planner := GOAPPlanner.new()
var _current_goal : Goal
var _current_plan : Plan

var _actor : Controller

func _physics_process(delta):
	var goal = _get_best_goal()
	if not goal:
		return
	if _current_goal == null or goal != _current_goal:
		_current_goal = goal
		Fn.LOG(_current_goal.goal_name())
		_current_plan =  _planner.get_plan(_current_goal, _world_state)
	else:
		_current_plan.follow_plan(_actor, delta, _world_state)
	

func init(actor, goals: Array[Goal], actions:Array[Action]):
	_actor = actor
	_goals = goals
	_actions = actions
	_world_state._state["HasSlept"]=false
	_planner.set_actions(_actions)
	add_child(_world_state)
	add_child(_planner)

#
# Returns the highest priosrity goal available.
#
func _get_best_goal():
	var highest_priority = null

	for goal in _goals:
		if goal.is_valid(_world_state) and (highest_priority == null or goal.priority() > highest_priority.priority()):
			highest_priority = goal
	return highest_priority
