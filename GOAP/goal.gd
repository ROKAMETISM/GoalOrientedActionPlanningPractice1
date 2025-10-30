class_name Goal extends Node

func goal_name()->String:
	return "BaseGoal"
func is_valid() -> bool:
	return true

func priority() -> int:
	return 1

func get_desired_state() -> Dictionary:
	return {}
