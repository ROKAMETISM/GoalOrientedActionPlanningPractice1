class_name GetGoldAction extends Action

func action_name()->String:
	return "GetGoldAction"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
		"SeenGoldOre" : true,
		"HasStonePickaxe" : true
	}
func get_effects() -> Dictionary:
	return {"HasGoldOre":true}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.get_gold(_delta, _world_state)
