class_name SleepGoal extends Goal
func goal_name()->String:
	return "SleepGoal"
func is_valid(local_world:LocalWorld) -> bool:
	return true


func priority(local_world:LocalWorld) -> int:
	return floori(local_world.get_state("TimeSinceLastSlept", 0.0) - 5)


func get_desired_state() -> Dictionary:
	return {
		"HasSlept":true
	}
