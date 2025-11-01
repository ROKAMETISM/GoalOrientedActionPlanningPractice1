class_name Fn extends Node
static var _log := true
static func enable_log(value:bool)->void:
	_log = value
static func LOG(text, tag : String = "LOG")->void:
	if not _log:
		return
	print(tag + ":"+str(text))
