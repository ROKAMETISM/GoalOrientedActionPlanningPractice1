class_name WanderGoal extends Goal
func goal_name()->String:
	return "WanderGoal"
func is_valid(_world_state:LocalWorld) -> bool:
	return true


func priority(_local_world:LocalWorld) -> int:
	return 0


func get_desired_state() -> Dictionary:
	return {
		"Wander":true
	}
