class_name GetStick extends Action

func action_name()->String:
	return "GetStick"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
		"SeenStick" : true
	}
func get_effects() -> Dictionary:
	return {"HasStick":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.get_stick(_delta, _world_state)
