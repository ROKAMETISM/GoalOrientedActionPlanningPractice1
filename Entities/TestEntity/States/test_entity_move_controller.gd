class_name TestEntityMovecontroller extends Controller


@onready var agent : GOAPAgent = %GOAPAgent

@export var sleep_time := 4.0
var _sleep_timer := sleep_time
var is_sleeping := false
var time_since_last_slept := 0.0

var is_idling := false

@export var wander_time_min := 2.0
@export var wander_time_max := 4.0
@export var wander_speed := 100.0
var _wander_direction := Vector2.ZERO
var _wander_timer := -1.0

var is_running := false
var run_direction := Vector2.ZERO

var is_searching := false
var _search_direction := Vector2.ZERO

func get_move()->Vector2:
	if is_sleeping or is_idling:
		return Vector2.ZERO
	if is_running:
		return run_direction
	if is_searching:
		return _search_direction
	return _wander_direction

func _physics_process(delta: float) -> void:
	if not is_sleeping:
		time_since_last_slept += delta
		if time_since_last_slept > 5.0:
			agent.set_state("HasSlept", false)
	agent.set_state("TimeSinceLastSlept", time_since_last_slept)
	parent.animate(_get_animation())

func _get_animation()->String:
	if is_sleeping:
		return "Fall"
	if is_idling:
		return "IDLE"
	if get_move():
		return "Move"
	return "IDLE"

func sleep(delta:float, _world_state:LocalWorld)->bool:
	is_idling = false
	if is_sleeping:
		_sleep_timer -= delta
		if _sleep_timer < 0.0:
			is_sleeping = false
			_world_state.set_state("HasSlept", true)
			time_since_last_slept = 0.0
			return true
		return false
	is_sleeping = true
	_sleep_timer = sleep_time - delta
	return false

func wander(delta:float, _world_state:LocalWorld)->bool:
	is_running = false
	is_searching = false
	is_sleeping = false
	is_idling = false
	if _wander_direction.length_squared() <= 1.0:
		_wander_direction = Vector2(wander_speed, 0.0).rotated(randf_range(0, 2*PI))
		_wander_timer = randf_range(wander_time_min, wander_time_max)
	_wander_timer -= delta
	if _wander_timer < 0.0:
		_wander_timer += randf_range(wander_time_min, wander_time_max)
		_wander_direction = Vector2(wander_speed, 0.0).rotated(randf_range(0, 2*PI))
	return false

func make_stone_pickaxe(_delta:float, local_world:LocalWorld)->bool:
	if local_world.get_state("HasStone",false) and local_world.get_state("HasStick",false):
		local_world.set_state("HasStone",false)
		local_world.set_state("HasStick",false)
		local_world.set_state("HasStonePickaxe",true)
		Fn.LOG("\n\nMADE PICKAXE!!!\n\n")
		return true
	return false

func get_stone(_delta:float, local_world:LocalWorld)->bool:
	is_running = true
	is_sleeping = false
	is_idling = false
	if not local_world.get_state("SeenStone", false):
		return false
	if local_world.get_state("HasStone", false):
		return true
	var seen_stone : PickUp = local_world.get_closest_seen("Stone", parent.global_position)
	var relative_position : Vector2 = seen_stone.global_position - parent.global_position
	relative_position = relative_position.normalized()*200
	run_direction = relative_position
	return agent.get_state("HasStone",false)


func get_stick(_delta:float, local_world:LocalWorld)->bool:
	is_running = true
	is_sleeping = false
	is_idling = false
	if not local_world.get_state("SeenStick", false):
		return false
	if local_world.get_state("HasStick", false):
		return true
	var seen_stick : PickUp = local_world.get_closest_seen("Stick", parent.global_position)
	var relative_position : Vector2 = seen_stick.global_position - parent.global_position
	relative_position = relative_position.normalized()*200
	run_direction = relative_position
	return agent.get_state("HasStick",false)


func get_gold(_delta:float, local_world:LocalWorld)->bool:
	is_running = true
	is_sleeping = false
	is_idling = false
	if not local_world.get_state("SeenGoldOre", false):
		return false
	if local_world.get_state("HasGoldOre", false):
		return true
	var seen_stick : PickUp = local_world.get_closest_seen("GoldOre", parent.global_position)
	var relative_position : Vector2 = seen_stick.global_position - parent.global_position
	relative_position = relative_position.normalized()*200
	run_direction = relative_position
	return agent.get_state("HasGoldOre",false)

func search(_delta:float, local_world:LocalWorld)->bool:
	is_searching = true
	is_sleeping = false
	is_idling = false
	if Engine.get_physics_frames()%60 <= 1:
		_search_direction = Vector2(250, 0).rotated(randf_range(0, 2*PI))
	return agent.get_state("HasStick",false) and agent.get_state("HasStone",false)


func go_to_box(_delta:float, local_world:LocalWorld)->bool:
	var box = local_world.get_state("BoxInstance",false)
	if box:
		is_running = true
		run_direction = parent.global_position.direction_to(box.global_position) * 140
	else:
		is_running = false
		is_searching = true
		if Engine.get_physics_frames()%60 <= 1:
			_search_direction = Vector2(250, 0).rotated(randf_range(0, 2*PI))
	return agent.get_state("TouchingBox", false)
	
func store_gold_to_box(_delta:float, local_world:LocalWorld)->bool:
	is_idling = true
	var box = local_world.get_state("BoxInstance",false)
	if not box:
		return true
	box.store("GoldOre", 1)
	agent.set_state("HasGoldOre", false)
	return not agent.get_state("HasGoldOre", false)
