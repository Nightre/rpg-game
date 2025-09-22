class_name HandManager
extends Node

@export var hand: Node2D
@export var player: Entity
@export var compositer: Compositer

var hand_item: InventoryItem
var hand_node: Holdable

var in_use = false

func equip(item_or_id) -> void:
	if hand_item:
		unequip()
	
	# Handle different input types
	if item_or_id is InventoryItem:
		hand_item = item_or_id
	elif item_or_id is String:
		# Assuming there's a way to get InventoryItem from ID
		hand_item = InventoryItem.new() # Replace with actual item fetching logic
		hand_item.set_property("id", item_or_id)
	else:
		return # Invalid input type
	
	var item_id = hand_item.get_property("id")
	var item_scene = Data.item_scene
	
	if item_id in item_scene:
		hand_node = Data.item_scene[item_id].instantiate()
	else:
		hand_node = preload("res://scene/world/default_holdable.tscn").instantiate()
		hand_node.image = hand_item.get_texture()
		
	hand_node.compositer = compositer
	if hand_node is HoldableWepone:
		hand_node.sender = player
		hand_node.team = player.team
	hand.add_child(hand_node)
	
func set_direction(rotation):
	if hand_node:
		hand_node.set_povit_dir(rotation)
	
func unequip() -> void:
	if hand_item:
		hand_item = null
		hand_node.queue_free()

func start_use() -> void:
	if hand_node and hand_node.can_use():
		hand_node.start_use()
		in_use = true

func end_use() -> void:
	if hand_node and in_use:
		hand_node.end_use()
		in_use = false

func auto_use():
	if hand_node and hand_node is HoldableWepone and hand_node.can_use():
		start_use()
		await hand_node.charge_completed
		end_use()
