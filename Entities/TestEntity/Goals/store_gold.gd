class_name StoreGoldGoal extends Goal
func goal_name()->String:
	return "StoreGoldGoal"
func is_valid(local_world:LocalWorld) -> bool:
	return local_world.get_state("HasGoldOre", false)


func priority(local_world:LocalWorld) -> int:
	return 6


func get_desired_state() -> Dictionary:
	return {
		"HasGoldOre":false
	}
