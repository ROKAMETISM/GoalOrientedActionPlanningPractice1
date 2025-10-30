extends Node
static var _log := false
static func enable_log(toggle:bool)->void:
	_log = toggle
static func LOG(text : String)->void:
	if not _log:
		return
	print("LOG:"+text)
