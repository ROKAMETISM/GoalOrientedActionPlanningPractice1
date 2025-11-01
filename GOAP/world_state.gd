class_name WorldState extends Node

var _state : Dictionary = {
}

func get_state(state_name : String, default = null):
	return _state.get(state_name, default)

func set_state(state_name:String, value)->void:
	_state[state_name] = value

func clear_state()->void:
	_state = {}
