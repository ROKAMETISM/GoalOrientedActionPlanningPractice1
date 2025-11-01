class_name TestEntityMove extends State
@export var idle_state : TestEntityIDLE
var animation := "Move"
func enter() -> void:
	super()
func process_physics(_delta: float) -> Array:
	var _output : Array = []
	if controllers[0].get_move():
		parent.velocity = controllers[0].get_move()
		parent.move_and_slide()
		return _output
	_set_single_state_transition(_output, idle_state)
	return _output
func get_state_name()->String:
	return "TestEntityMove"
