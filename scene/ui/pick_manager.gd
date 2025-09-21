class_name PickManager extends Node

@onready var inventory: Inventory = $"../InventoryData"
@export var map:Node2D
@export var player:Player
@export var drop_manager:DropsManager

func pick(item:InventoryItem, num:int):
	inventory.add_item(item)
	
func drop(item:InventoryItem):
	inventory.remove_item(item)
	var drop = preload("res://scene/world/drop_inventory_item.tscn").instantiate()
	drop.disable_time = 1
	drop.item = item
	drop.pick_manager = self
	map.add_child(drop)
	var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 3
	drop.global_position = player.global_position + offset
	
