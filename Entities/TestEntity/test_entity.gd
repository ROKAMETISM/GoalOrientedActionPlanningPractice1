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
			WanderGoal.new(),
			GetStonePickaxe.new(),
			],
			[SleepAction.new(),
			WanderAction.new(),
			MakeStonePickaxe.new(),
			GetStone.new(),
			GetStick.new(),
			SearchStick.new(),
			SearchStone.new()
			])
			
func _physics_process(_delta: float) -> void:
	global_position = global_position.posmodv(get_viewport().size)
	goap_text.visualize_agent(agent)

func animate(animation_name : String)->void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)

func pickup(item_pickup : PickUp)->void:
	var item : Item = item_pickup.item_data
	var state_name : String = "Has%s"%item.item_name
	if not agent.get_state(state_name, false):
		agent.set_state(state_name, true)
		item_pickup.queue_free()


func _on_sight_area_entered(area: Area2D) -> void:
	var item_pickup = area as PickUp
	agent.see_item(item_pickup)
