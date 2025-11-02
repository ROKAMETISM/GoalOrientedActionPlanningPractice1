class_name GoToBox extends Action

func action_name()->String:
	return "GoToBox"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
	}
func get_effects() -> Dictionary:
	return {"TouchingBox":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.go_to_box(_delta, _world_state)
