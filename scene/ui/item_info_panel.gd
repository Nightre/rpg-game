extends Panel

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var name_label: Label = $NameLabel
@onready var eat_button: Button = $EatButton
@onready var texture_rect: TextureRect = $TextureRect
@export var inventory: Inventory

@export var eat_manager:EatManager

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
