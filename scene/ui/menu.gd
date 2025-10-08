extends ColorRect
@onready var setting_dialog: AcceptDialog = $VBoxContainer/SettingDialog

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if visible:
			close_menu()
		else:
			open_menu()

func open_menu():
	visible = true
	get_tree().paused = true
	
func close_menu():
	visible = false
	get_tree().paused = false

func _on_quit_pressed() -> void:
	SaveManager.save_current()
	get_tree().quit()

func _on_setting_pressed() -> void:
	setting_dialog.popup()

func _on_back_pressed() -> void:
	close_menu()

func _on_go_start_scene_pressed() -> void:
	go_start_scene()
	
func go_start_scene():
	get_tree().paused = false
	SceneLoading.start_show()
	SceneLoading.label.text = "保存中..."
	SaveManager.save_current()
	SceneLoading.load_scene("res://scene/ui/start.tscn")
