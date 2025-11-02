class_name TestEntityIDLE extends State

@export var move_state : TestEntityMove

func enter() -> void:
	super()

func process_physics(_delta: float) -> Array[Transition]:
	var _output:Array[Transition]
	if controllers[0].get_move():
		_set_single_state_transition(_output, move_state)
	return _output

func get_state_name()->String:
	return "TestEntityIDLE"
