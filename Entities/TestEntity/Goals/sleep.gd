class_name SleepGoal extends Goal
func goal_name()->String:
	return "SleepGoal"
func is_valid(local_world:LocalWorld) -> bool:
	return not local_world.get_state("HasSlept", true)


func priority() -> int:
	return 5


func get_desired_state() -> Dictionary:
	return {
		"HasSlept":true
	}
