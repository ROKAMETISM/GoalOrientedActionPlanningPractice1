class_name GetStone extends Action

func action_name()->String:
	return "GetStone"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
		"SeenStone" : true
	}
func get_effects() -> Dictionary:
	return {"HasStone":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.get_stone(_delta, _world_state)
