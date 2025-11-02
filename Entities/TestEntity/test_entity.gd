extends CharacterBody2D

@onready var move_fsm : FSM = %FSM
@onready var move_controller : TestEntityMovecontroller = %TestEntityMovecontroller
@onready var agent : GOAPAgent = %GOAPAgent
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var goap_text : Label = %GOAPText

func _ready()->void:
	move_fsm.init(self, [move_controller])
	move_controller.init(self, move_fsm)
	agent.init(move_controller, 
			[SleepGoal.new(),
			WanderGoal.new()],
			[SleepAction.new(),
			WanderAction.new()])
			
func _physics_process(_delta: float) -> void:
	global_position = global_position.posmodv(get_viewport().size)
	goap_text.visualize_agent(agent)

func animate(animation_name : String)->void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)
