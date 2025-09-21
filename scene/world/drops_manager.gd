class_name DropsManager extends Node

@export var map:Node2D
@export var player_info:PlayerInfo
@export var pick_manager:PickManager
@export var inventory:Inventory
func _init() -> void:
	Global.drops = self

func add_drop(item:String, pos:Vector2):
	var instance = preload("res://scene/world/drop_coin.tscn") if item == "coin" else preload("res://scene/world/drop_inventory_item.tscn")
	instance = instance.instantiate()
	var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 10
	if item == "coin":
		instance.player_info = player_info
	else:
		instance.item = inventory.create_item(item)
		instance.pick_manager = pick_manager
		
	instance.position = pos + offset
	instance.disable_time = 0.5
	map.add_child(instance)
	
