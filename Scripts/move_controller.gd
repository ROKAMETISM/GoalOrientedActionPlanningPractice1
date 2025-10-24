class_name MoveController
extends Node
var parent:CharacterBody3D
func move_input() -> Vector2:
	return Vector2.ZERO
func sprint_input() -> bool:
	return false
func jump_input() -> bool:
	return false
func init(new_parent:CharacterBody3D)->void:
	parent = new_parent
