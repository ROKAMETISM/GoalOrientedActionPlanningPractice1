class_name Fn extends Node
static var _log := true
static func enable_log(value:bool)->void:
	_log = value
static func LOG(text, tag : String = "LOG")->void:
	if not _log:
		return
	print(tag + ":"+str(text))

static func randv2_range(from, to)->Vector2:
	var result := from as Vector2
	to = Vector2(to)
	result.x = randf_range(from.x, to.x)
	result.y = randf_range(from.y, to.y)
	return result

static func get_distance(reference_position:Vector2, node:Node)->float:
	return (reference_position - node.global_position).length()
