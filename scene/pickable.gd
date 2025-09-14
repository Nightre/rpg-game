extends Node2D

@export var item = ""

func _on_actionable_interacted() -> void:
	Global.current_game.inventory.create_and_add_item(item)
	queue_free()
