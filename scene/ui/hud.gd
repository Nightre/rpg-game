class_name HUD extends Control

@onready var inventory: Control = %Inventory
@onready var inventory_container: HBoxContainer = $InventoryContainer

var open_inventory = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		set_open_inventory(!open_inventory)
		
func set_open_inventory(new_open_inventory):
	open_inventory = new_open_inventory
	inventory_container.visible = open_inventory
	inventory.open()
