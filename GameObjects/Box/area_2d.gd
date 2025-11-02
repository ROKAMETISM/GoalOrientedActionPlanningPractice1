extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("touch_box"):
		body.touch_box(get_parent(), true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("touch_box"):
		body.touch_box(get_parent(), false)

func is_box()->bool:
	return true
