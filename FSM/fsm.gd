class_name FSM
extends Node

signal state_updated(new_states : Array[State])
@export var starting_states:Array[State]
var _current_states:Array[State]

func _physics_process(delta: float) -> void:
	for current_state_element in _current_states:
		var state_change_data = current_state_element.process_physics(delta)
		change_state(state_change_data)

func _unhandled_input(event: InputEvent) -> void:
	for current_state_element in _current_states:
		var state_change_data = current_state_element.process_input(event)
		change_state(state_change_data)

func _process(delta: float) -> void:
	for current_state_element in _current_states:
		var state_change_data = current_state_element.process_frame(delta)
		change_state(state_change_data)

func init(parent:Node, controllers:Array[Controller]) -> void:
	for child : State in get_children():
		child.parent = parent
		child.fsm = self
		child.controllers = controllers
	var state_transition_array := []
	for starting_state_element in starting_states:
		state_transition_array.append(Transition.new(starting_state_element, Transition.Type.Enter))
	change_state(state_transition_array)

func change_state(data:Array) -> void:
	for transition:Transition in data:
		match transition.operation_type:
			Transition.Type.Enter:
				if _current_states.has(transition.new_state):
					continue
				_current_states.append(transition.new_state)
				transition.new_state.enter()
			Transition.Type.Exit:
				if not _current_states.has(transition.new_state):
					continue
				_current_states.erase(transition.new_state)
				transition.new_state.exit()
	state_updated.emit(_current_states)

func str__current_states()->String:
	var _output:=""
	for state_element in _current_states:
		_output += state_element.get_state_name()
		_output += " "
	return _output
