class_name StoreGoldToBox extends Action

func action_name()->String:
	return "StoreGoldToBox"
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1
func get_preconditions() -> Dictionary:
	return {
		"HasGoldOre" : true,
		"TouchingBox" : true
	}
func get_effects() -> Dictionary:
	return {"HasGoldOre":false}
func perform(_actor, _delta, _world_state) -> bool:
	return _actor.store_gold_to_box(_delta, _world_state)
