extends Area2D

@export var item_data : Item

@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Label

func _ready() -> void:
	if not item_data:
		queue_free()
		return
	sprite.texture = item_data.in_world_texture
	label.text = item_data.name
