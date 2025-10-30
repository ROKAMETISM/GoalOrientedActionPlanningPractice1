class_name TestEntityMove extends State
func enter() -> void:
	super()
func process_physics(_delta: float) -> Array:
	parent.velocity = controllers[0].get_move()
	parent.move_and_slide()
	return []
func get_state_name()->String:
	return "TestEntityMove"
