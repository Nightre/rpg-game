extends Button
signal delete_pressed

@export var archive_name = ""

func _ready() -> void:
	text = archive_name


func _on_delete_button_pressed() -> void:
	delete_pressed.emit()
