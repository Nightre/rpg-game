extends Panel

@onready var pick_manager: PickManager = $"../../../PickManager"
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var name_label: Label = $NameLabel
@onready var eat_button: Button = %EatButton
@onready var equipment_button: Button = %EquipmentButton
@onready var equipment_manager: Node = $"../../../EquipmentManager"
@onready var build_button: Button = %BuildButton
@onready var use_button: Button = %UseButton

@onready var texture_rect: TextureRect = $TextureRect
@export var inventory: Inventory
@export var build_manager:BuildManager
@export var eat_manager:EatManager
@export var use_manager:UseManager

var selected_item:InventoryItem

func _on_ctrl_inventory_grid_inventory_item_selected(item: InventoryItem) -> void:
	show()
	select_item(item)

func select_item(item):
	selected_item = item
	if item:
		name_label.text = item.get_title()
		texture_rect.texture = item.get_texture()
		eat_button.visible = item.get_property("edible", false)
		equipment_button.visible = item.get_property("equippable", false)
		build_button.visible = item.get_property("buildable", false)
		use_button.visible = item.get_property("useable", false)
		rich_text_label.text = item.get_property("info", "该物品没有描述...")
		selected_item = item
		show()
	else:
		hide()

func init_info():
	hide()
	select_item(null)

func _on_eat_button_pressed() -> void:
	if selected_item:
		eat_manager.eat_time(inventory, selected_item)


func _on_inventory_data_item_removed(item: InventoryItem) -> void:
	if item == selected_item:
		select_item(null)

func _on_discard_button_pressed() -> void:
	if selected_item:
		pick_manager.drop(selected_item)

func _on_equipment_button_pressed() -> void:
	if selected_item:
		equipment_manager.equip(selected_item)


func _on_build_button_pressed() -> void:
	if selected_item:
		build_manager.select_building(selected_item)

func _on_use_button_pressed() -> void:
	if selected_item:
		use_manager.select_item(selected_item)
