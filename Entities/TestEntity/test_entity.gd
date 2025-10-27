extends CharacterBody2D

@onready var move_fsm : FSM = %MoveFSM
@onready var move_controller : TestEntityMovecontroller = %TestEntityMovecontroller

func _ready()->void:
	move_fsm.init(self, [move_controller])
	move_controller.init(self)
