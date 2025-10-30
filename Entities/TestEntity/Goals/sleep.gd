class_name SleepGoal extends Goal
func goal_name()->String:
	return "SleepGoal"
func is_valid() -> bool:
	return true


func priority() -> int:
	return 0


func get_desired_state() -> Dictionary:
	return {
	}
