extends Node

enum my_state {
	Idle,
	Move,
	Test
}

var direction : int


func _ready() -> void:
	if not is_moving() : direction = 0
	
func get_state_name(state : my_state)->String:
	return my_state.keys().get(state)

func is_moving()->bool:
	return false
