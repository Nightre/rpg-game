class_name EatManager extends Node
@onready var effect_manager: EffectManager = $"../EffectManager"
@onready var player_info: PlayerInfo = $"../PlayerInfo"

func eat_time(inventory:Inventory ,item:InventoryItem):
	inventory.remove_item(item)
	
	if item.get_property("health"):
		player_info.hp += item.get_property("health")
		
	for effect in item.get_property("effects", []):
		effect_manager.give_effect(effect)
