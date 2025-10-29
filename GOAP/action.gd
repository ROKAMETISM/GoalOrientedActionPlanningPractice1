class_name Action extends Node
func is_valid() -> bool:
	return true
func get_cost(_blackboard : Dictionary)->int:
	return 1000
func get_preconditions() -> Dictionary:
	return {}
func get_effects() -> Dictionary:
	return {}
func perform(_actor, _delta) -> bool:
	return false
