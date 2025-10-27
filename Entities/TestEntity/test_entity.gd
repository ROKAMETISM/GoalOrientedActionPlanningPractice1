extends CharacterBody2D

@onready var fsm : FSM = $FSM

func _ready()->void:
	fsm.init(self, [])
