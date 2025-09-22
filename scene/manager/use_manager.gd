class_name UseManager extends Node
@onready var use_cursor: Sprite2D = $"../UseCursor"
@onready var map: Node2D = $"../Map"
@onready var area_2d: UseArea = $"../UseCursor/Area2D"

signal using_selected(item: InventoryItem)

var selected_item:InventoryItem
var can_use = false

func select_item(item:InventoryItem):
	selected_item = item
	if item:
		use_cursor.texture = item.get_texture()
	use_cursor.visible = selected_item is InventoryItem
	using_selected.emit(selected_item)
	if selected_item:
		Global.hud.state = Global.hud.STATE.USEING 
	else:
		Global.hud.state = Global.hud.STATE.IDLE 

func _process(delta: float) -> void:
	if selected_item:
		use_cursor.position = map.get_local_mouse_position()
		if area_2d.current_buildable:
			can_use = area_2d.current_buildable.can_use(selected_item)
		else:
			can_use = false
		if can_use:
			use_cursor.modulate = Color(0, 1, 0, 0.7)
		else:
			use_cursor.modulate = Color(1, 0, 0, 0.7)
			
func _input(event: InputEvent) -> void:
	if selected_item:
		if Input.is_action_just_released("build") and can_use:
			area_2d.current_buildable.use_item(selected_item)
			select_item(null)
		elif Input.is_action_just_pressed("cancel"):
			select_item(null)
