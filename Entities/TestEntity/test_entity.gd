extends CharacterBody2D

@onready var move_fsm : FSM = %FSM
@onready var move_controller : TestEntityMovecontroller = %TestEntityMovecontroller
@onready var agent : GOAPAgent = %GOAPAgent
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D

func _ready()->void:
	move_fsm.init(self, [move_controller])
	move_fsm.state_updated.connect(_on_move_fsm_state_updated)
	move_controller.init(self)
	agent.init(move_controller, 
			[SleepGoal.new(),
			WanderGoal.new()],
			[SleepAction.new(),
			WanderAction.new()])

func _physics_process(_delta: float) -> void:
	global_position = global_position.posmodv(get_viewport().size)

func _on_move_fsm_state_updated(states : Array[State])->void:
	for state in states:
		sprite.play(state.animation)
