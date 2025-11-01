class_name Action extends Node
func action_name()->String:
	return "BaseAction"
func is_valid() -> bool:
	return true
func get_cost(_world_state : Dictionary)->int:
	return 1000
func get_preconditions() -> Dictionary:
	return {}
func get_effects() -> Dictionary:
	return {}
func perform(_actor : Controller, _delta : float, _local_world : LocalWorld) -> bool:
	return false
