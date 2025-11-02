class_name TestEntityMovecontroller extends Controller


@onready var agent : GOAPAgent = %GOAPAgent

@export var sleep_time := 4.0
var _sleep_timer := sleep_time
var is_sleeping := false
var time_since_last_slept := 0.0

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
	if is_sleeping:
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
	if get_move():
		return "Move"
	return "IDLE"

func sleep(delta:float, _world_state:LocalWorld)->bool:
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
		return true
	return false

func get_stone(_delta:float, local_world:LocalWorld)->bool:
	is_running = true
	var seen_stone : PickUp = local_world.seen_items.get("Stone")[0]
	var relative_position : Vector2 = seen_stone.global_position - parent.global_position
	relative_position = relative_position.normalized()*200
	run_direction = relative_position
	return local_world.get_state("HasStone",false)


func get_stick(_delta:float, local_world:LocalWorld)->bool:
	is_running = true
	var seen_stick : PickUp = local_world.seen_items.get("Stick")[0]
	var relative_position : Vector2 = seen_stick.global_position - parent.global_position
	relative_position = relative_position.normalized()*200
	run_direction = relative_position
	return local_world.get_state("HasStick",false)

func search(_delta:float, local_world:LocalWorld)->bool:
	is_searching = true
	if Engine.get_physics_frames()%60 <= 1:
		_search_direction = Vector2(250, 0).rotated(randf_range(0, 2*PI))
	return local_world.get_state("HasStick",false) and local_world.get_state("HasStone",false)
