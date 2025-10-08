extends ColorRect

@onready var menu: ColorRect = $"../Menu"

func _ready() -> void:
	Online.multiplayer.server_disconnected.connect(
		func ():
			show()
			get_tree().paused = true	
	)

func _on_button_pressed() -> void:
	menu.go_start_scene()
