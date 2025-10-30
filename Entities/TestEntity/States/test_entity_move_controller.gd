class_name TestEntityMovecontroller extends Controller
func get_move()->Vector2:
		return Vector2(100,0).rotated(randf_range(0, 2*PI))
