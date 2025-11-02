extends Node2D

var spawn_timer := 0.5

const PICKUP := preload("uid://6t2e6nc4cj8s")

const STONE := preload("uid://xxjmeogmth2x")
const STICK := preload("uid://cnsuhw8e4qaof")
const IRON := preload("uid://pm3va3nt8rfm")

var item_types : Array[Item]

func _ready() -> void:
	item_types.append(STONE)
	item_types.append(STICK)
	item_types.append(IRON)

func _physics_process(delta: float) -> void:
	
	spawn_timer -= delta
	if spawn_timer < 0:
		spawn_timer += 1.5
		var new_pickup : PickUp= PICKUP.instantiate()
		new_pickup.item_data = item_types.pick_random()
		new_pickup.global_position = Vector2(randf_range(0, 300),0).rotated(randf_range(0, 2*PI)) \
				+ Vector2(get_viewport().size/2)
		add_child(new_pickup)
