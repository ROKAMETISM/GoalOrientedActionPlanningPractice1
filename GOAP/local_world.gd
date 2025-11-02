class_name LocalWorld extends Node

var _state : Dictionary = {
}
#Key : ItemType
#Value : Array of Instantiated PickUps of the item type
var seen_items : Dictionary[String, Array]

func get_state(state_name : String, default = null):
	return _state.get(state_name, default)


func get_states()->Dictionary:
	_update_seen_items()
	return _state.duplicate()


func set_state(state_name:String, value)->void:
	_state[state_name] = value

func clear_state()->void:
	_state = {}

func str_state()->String:
	var _output := ""
	var state = get_states()
	for state_name:String in state.keys():
		_output += "[%s:"%state_name
		var value = state.get(state_name, null)
		match typeof(value):
			TYPE_FLOAT:
				_output += "%.2f"%value
			TYPE_NIL:
				_output += "null"
			_:
				_output += str(value)
		_output += "]\n"
	return _output

func _update_seen_items()->void:
	for item_name:String in seen_items:
		set_state("Seen%s"%item_name, false)
		for instance in seen_items.get(item_name):
			if is_instance_valid(instance):
				set_state("Seen%s"%item_name, true)
			else:
				seen_items.get(item_name).erase(instance)
