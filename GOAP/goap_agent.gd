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


func set_state(state_name:String, value)->void:
	_local_world.set_state(state_name, value)

func get_state(state_name:String, default:Variant=null)->Variant:
	return _local_world.get_state(state_name, default)

func see_item(item_pickup:PickUp)->void:
	var item_array = _local_world.seen_items.get(item_pickup.item_data.item_name)
	if not item_array:
		_local_world.seen_items.set(item_pickup.item_data.item_name, [])
		item_array = _local_world.seen_items.get(item_pickup.item_data.item_name)
	item_array.append(item_pickup)

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
	return goal.is_valid(_local_world) and (current_goal == null or goal.priority(_local_world) > current_goal.priority(_local_world))


func _is_new_best_goal(goal:Goal)->bool:
	return _current_goal == null or goal != _current_goal
