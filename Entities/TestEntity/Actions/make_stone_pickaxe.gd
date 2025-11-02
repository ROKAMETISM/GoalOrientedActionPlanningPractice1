class_name MakeStonePickaxe extends Action

func action_name()->String:
	return "MakeStonePickaxe"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
		"HasStone" : true,
		"HasStick" : true
	}
func get_effects() -> Dictionary:
	return {"HasStonePickaxe":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.make_stone_pickaxe(_delta, _world_state)
