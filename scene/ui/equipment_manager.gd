extends Node
@onready var equipment_item_slot: ItemSlot = $"../Equipment/EquipmentItemSlot"
@onready var inventory_data: Inventory = $"../InventoryData"
@onready var item_info_panel: Panel = $"../Panel/HBoxContainer/ItemInfoPanel"
@export var hand_manager:HandManager


func equip(item:InventoryItem):
	if equipment_item_slot.get_item():
		inventory_data.add_item(equipment_item_slot.get_item())
		equipment_item_slot.clear()
	equipment_item_slot.equip(item)


func _on_equipment_item_slot_cleared(item: InventoryItem) -> void:
	hand_manager.unequip()

func _on_equipment_item_slot_item_equipped() -> void:
	hand_manager.equip(equipment_item_slot.get_item())
