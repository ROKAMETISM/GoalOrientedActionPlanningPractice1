class_name GOAPAgent extends Node
var _goals : Array[Goal]
var _actions : Array[Action]
var _local_world := LocalWorld.new()
var _planner := GOAPPlanner.new()
var _current_goal : Goal
var _current_plan : Plan

var _actor

func _physics_process(delta:float)->void:
	var goal : Goal = _get_best_goal()
	if not goal:
		return
	if _is_new_best_goal(goal):
		_current_goal = goal
		Fn.LOG(_current_goal.goal_name(), "CurrentGoalUpdated")
		_current_plan =  _planner.get_plan(_current_goal, _local_world)
	else:
		_current_plan.follow_plan(_actor, delta, _local_world)
	

func init(actor, goals: Array[Goal], actions:Array[Action]):
	_actor = actor
	_goals = goals
	_actions = actions
	_local_world._state["HasSlept"]=false
	_planner.set_actions(_actions)
	add_child(_local_world)
	add_child(_planner)

#
# Returns the highest priosrity goal available.
#
func _get_best_goal()->Goal:
	var highest_priority = null
	for goal in _goals:
		if _is_better_goal(goal, highest_priority):
			highest_priority = goal
	return highest_priority


func _is_better_goal(goal:Goal, current_goal:Goal)->bool:
	return goal.is_valid(_local_world) and (current_goal == null or goal.priority() > current_goal.priority())


func _is_new_best_goal(goal:Goal)->bool:
	return _current_goal == null or goal != _current_goal
