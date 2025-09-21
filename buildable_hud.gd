class_name BuildableHud extends Control

@export var buildable:Buildable

func _on_button_pressed() -> void:
	buildable.destory()
