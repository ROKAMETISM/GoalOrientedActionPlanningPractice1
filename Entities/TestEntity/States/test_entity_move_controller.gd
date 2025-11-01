class_name TestEntityMovecontroller extends Controller

@export var sleep_time := 2.0
var _sleep_timer := sleep_time
var is_sleeping := false

@export var wander_time := 3.0
@export var wander_speed := 100.0
var _wander_direction := Vector2.ZERO
var _wander_timer := wander_time

func get_move()->Vector2:
	if is_sleeping:
		return Vector2.ZERO
	
	return _wander_direction

func sleep(delta:float, _world_state:LocalWorld)->bool:
	if is_sleeping:
		_sleep_timer -= delta
		if _sleep_timer < 0.0:
			is_sleeping = false
			_world_state.set_state("HasSlept", true)
			return true
		return false
	is_sleeping = true
	_sleep_timer = sleep_time - delta
	return false

func wander(_delta, _world_state)->bool:
	if _wander_direction.length_squared() <= 1.0:
		_wander_direction = Vector2(wander_speed, 0.0).rotated(randf_range(0, 2*PI))
	_wander_timer -= _delta
	if _wander_timer < 0.0:
		_wander_timer += wander_time
		_world_state.set_state("HasSlept", false)
		_wander_direction = Vector2(wander_speed, 0.0).rotated(randf_range(0, 2*PI))
	return false
