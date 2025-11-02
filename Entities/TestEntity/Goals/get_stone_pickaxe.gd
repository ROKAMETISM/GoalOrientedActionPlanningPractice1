class_name GetStonePickaxe extends Goal
func goal_name()->String:
	return "GetStonePickaxeGoal"
func is_valid(local_world:LocalWorld) -> bool:
	return not local_world.get_state("HasStonePickaxe", false)


func priority(local_world:LocalWorld) -> int:
	return 20


func get_desired_state() -> Dictionary:
	return {
		"HasStonePickaxe":true
	}
