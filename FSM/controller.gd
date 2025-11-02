class_name Controller
extends Node
var parent:Node
var fsm : FSM
func init(new_parent:Node, new_fsm:FSM)->void:
	parent = new_parent
	fsm = new_fsm
