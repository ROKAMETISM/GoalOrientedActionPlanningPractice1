extends Node2D

var spawn_timer := 0.5

const PICKUP := preload("uid://6t2e6nc4cj8s")

const STONE := preload("uid://xxjmeogmth2x")
const STICK := preload("uid://cnsuhw8e4qaof")
const IRON := preload("uid://pm3va3nt8rfm")
const GOLD := preload("uid://bk286ks0moxyp")

var item_types : Array[Item]

func _ready() -> void:
	item_types.append(STONE)
	item_types.append(STICK)
	item_types.append(IRON)
	item_types.append(GOLD)
	randomize()
	Engine.time_scale = 3.0

func _physics_process(delta: float) -> void:
	
	spawn_timer -= delta
	if spawn_timer < 0:
		spawn_timer += 1.0
		var new_pickup : PickUp= PICKUP.instantiate()
		new_pickup.item_data = item_types.pick_random()
		new_pickup.global_position = Fn.randv2_range(Vector2(32, 32), get_viewport().size-Vector2i(32, 32))
		add_child(new_pickup)
