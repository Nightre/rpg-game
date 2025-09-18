class_name HandManager
extends Node

@onready var hand: Node2D = %"Hand"
@onready var player: Player = $".."
@export var compositer:Compositer

var hand_item:InventoryItem
var hand_node:Holdable

var in_use = false

func equip(item: InventoryItem) -> void:
	if hand_item:
		unequip()
	hand_item = item
	hand_node = Data.item_scene[item.get_property("id")].instantiate()
	hand_node.compositer = compositer
	hand.add_child(hand_node)
	print("手持", hand_node)
	
func _process(delta: float) -> void:
	if hand_node:
		if  player.velocity.length() == 0:
			hand_node.direction = Vector2.RIGHT
			hand_node.direction.x *= player.scale.x
		else:
			hand_node.direction = player.velocity
	
func unequip() -> void:
	if hand_item:
		hand_item = null
		hand_node.queue_free()

func start_use() -> void:
	if hand_node and hand_node.can_use():
		hand_node.start_use()
		in_use=true

func end_use() -> void:
	if hand_node and in_use:
		hand_node.end_use()
		in_use=false
