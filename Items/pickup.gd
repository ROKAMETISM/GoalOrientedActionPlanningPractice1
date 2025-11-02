class_name PickUp extends Area2D

@export var item_data : Item

@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Label

var _decay_timer : float

func _ready() -> void:
	if not item_data:
		queue_free()
		return
	sprite.texture = item_data.in_world_texture
	label.text = item_data.item_name
	_decay_timer = item_data.decay_time
	

func _physics_process(delta: float) -> void:
	_decay_timer -= delta
	if _decay_timer <= 0.0:
		queue_free.call_deferred()
		return



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(self)
