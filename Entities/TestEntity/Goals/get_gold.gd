class_name GetGoldGoal extends Goal
func goal_name()->String:
	return "GetGoldGoal"
func is_valid(local_world:LocalWorld) -> bool:
	return not local_world.get_state("HasGoldOre", false)


func priority(local_world:LocalWorld) -> int:
	return 5


func get_desired_state() -> Dictionary:
	return {
		"HasGoldOre":true
	}
