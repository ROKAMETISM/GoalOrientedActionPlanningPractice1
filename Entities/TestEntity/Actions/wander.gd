class_name WanderAction extends Action

func action_name()->String:
	return "WanderAction"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {}
func get_effects() -> Dictionary:
	return {"Wander":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.wander(_delta, _world_state)
