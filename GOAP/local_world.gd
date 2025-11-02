class_name LocalWorld extends Node

var _state : Dictionary = {
}

func get_state(state_name : String, default = null):
	return _state.get(state_name, default)

func set_state(state_name:String, value)->void:
	_state[state_name] = value

func clear_state()->void:
	_state = {}

func str_state()->String:
	var _output := ""
	for state_name:String in _state.keys():
		_output += "[%s:"%state_name
		var value = _state.get(state_name, null)
		match typeof(value):
			TYPE_FLOAT:
				_output += "%.2f"%value
			TYPE_NIL:
				_output += "null"
			_:
				_output += str(value)
		_output += "], "
	return _output
