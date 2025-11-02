class_name Box extends StaticBody2D

@onready var label : Label = %Label

##key:ItemName, value:amount
var inventory : Dictionary[String, int]

func store(item_name:String, amount:int)->void:
	var prev_amount = inventory.get(item_name, -1)
	if prev_amount < 0:
		inventory.set(item_name, amount)
	else:
		inventory.set(item_name, prev_amount + amount)
	label.text = "Gold : %d"%inventory.get("GoldOre", 0)
