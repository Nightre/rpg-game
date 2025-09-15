extends Node2D

@export var item = ""
@export var inventory:Inventory

func _on_actionable_interacted() -> void:
	inventory.create_and_add_item(item)
	queue_free()
