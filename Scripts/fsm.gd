extends Node
class_name FSM
@export var starting_states:Array[State]
var current_states:Array[State]
signal state_updated(new_states : Array[State])
func init(parent:CharacterBody3D, move_controller:MoveController) -> void:
	for child : State in get_children():
		child.parent = parent
		child.fsm = self
		child.move_controller = move_controller
	var state_transition_array := []
	for starting_state_element in starting_states:
		state_transition_array.append(Transition.new(starting_state_element, Transition.Type.Enter))
	change_state(state_transition_array)
func change_state(data:Array) -> void:
	for transition:Transition in data:
		match transition.operation_type:
			Transition.Type.Enter:
				if current_states.has(transition.new_state):
					continue
				current_states.append(transition.new_state)
				transition.new_state.enter()
			Transition.Type.Exit:
				if not current_states.has(transition.new_state):
					continue
				current_states.erase(transition.new_state)
				transition.new_state.exit()
	state_updated.emit(current_states)
func process_physics(delta: float) -> void:
	for current_state_element in current_states:
		var state_change_data = current_state_element.process_physics(delta)
		change_state(state_change_data)
func process_input(event: InputEvent) -> void:
	for current_state_element in current_states:
		var state_change_data = current_state_element.process_input(event)
		change_state(state_change_data)
func process_frame(delta: float) -> void:
	for current_state_element in current_states:
		var state_change_data = current_state_element.process_frame(delta)
		change_state(state_change_data)
func str_current_states()->String:
	var _output:=""
	for state_element in current_states:
		_output += state_element.get_state_name()
		_output += " "
	return _output
