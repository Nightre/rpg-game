class_name InventoryGUI extends Control

@onready var parent = get_parent()
	
func _ready() -> void:
	hide()
	
func open(hud:HUD):
	show()
	reparent(hud.inventory_container, false)
	
func close():
	hide()
	reparent(parent)
