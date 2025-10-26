class_name Transition
extends Resource
enum Type {
	Enter,
	Exit
}
var operation_type := Type.Enter
var new_state : State
func _init(state:State, op_type:Type):
	new_state = state
	operation_type = op_type
