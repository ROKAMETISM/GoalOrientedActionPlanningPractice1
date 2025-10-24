class_name State
extends Node
# Hold a reference to the parent so that it can be controlled by the state
@export var state_log := false
var parent:CharacterBody3D
var fsm:FSM
func enter() -> void:
	if state_log:
		print("++entered : " + get_state_name())
	pass
func exit() -> void:
	if state_log:
		print("--exiting : " + get_state_name())
	pass
func process_input(_event: InputEvent) -> Array:
	return []
func process_frame(_delta: float) -> Array:
	return []
func process_physics(_delta: float) -> Array:
	return []
func get_current_states()->Array[State]:
	return fsm.current_states
func is_active()->bool:
	return fsm.current_states.has(self)
func is_state_active(state:State)->bool:
	return fsm.current_states.has(state)
func get_state_name()->String:
	return "BaseStateName"
func _exit_transition(output:Array, exit_state:State)->void:
	output.append(Transition.new(exit_state, Transition.Type.Exit))
func _enter_transition(output:Array, exit_state:State)->void:
	output.append(Transition.new(exit_state, Transition.Type.Enter))
func _set_single_state_transition(output:Array, new_state:State)->void:
	output.append(Transition.new(self, Transition.Type.Exit))
	output.append(Transition.new(new_state, Transition.Type.Enter))
