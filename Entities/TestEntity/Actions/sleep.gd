class_name SleepAction extends Action

func action_name()->String:
	return "SleepAction"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {}
func get_effects() -> Dictionary:
	return {"HasSlept":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.sleep(_delta, _world_state)
