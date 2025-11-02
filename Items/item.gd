class_name Item extends Resource

@export var item_name : String
@export var decay_time : float
@export var in_world_texture : Texture2D
@export var state_required_to_pickup : Dictionary[String, Variant]= {}
@export var state_effect_on_pickup : Dictionary[String, Variant]={}
