extends VBoxContainer
@onready var confirmation_delete_dialog: ConfirmationDialog = $"../../ConfirmationDeleteDialog"

var current_delete_archive = null

func _ready() -> void:
	update_list()
	Online.multiplayer.connection_failed.connect(connect_faild)
	Online.multiplayer.connected_to_server.connect(load_game)
		
func update_list():
	for child in get_children():
		child.queue_free()
		
	for archive in SaveManager.get_save_list():
		var card = preload("res://scene/ui/archive_button.tscn").instantiate()
		card.archive_name = archive
		card.pressed.connect(func(): start_game(archive))
		card.delete_pressed.connect(func(): delete_save(archive))
		
		add_child(card)

func start_game(archive=null):
	SceneLoading.start_show()
	if archive:
		Global.current_archive["archive"] = archive
		SceneLoading.label.text = "读取存档中..."
		Global.current_archive["data"] = SaveManager.load_game(archive)
		
	if Online.online_type == Online.ONLINE_TYPE.SERVER:
		SceneLoading.label.text = "创建服务器中..."
		var error = Online.create_game()
		print("SERVER error： ", error)
		if error != OK:
			connect_faild()
			return	
		load_game()
			
	elif Online.online_type == Online.ONLINE_TYPE.CLIENT:
		SceneLoading.label.text = "连接中..."		
		var error = Online.join_game()
		print("CLIENT error： ", error)
		if error != OK:
			connect_faild()
			return
	else:
		load_game()

func load_game():
	SceneLoading.load_scene("res://scene/world/game.tscn")
	
func connect_faild():
	SceneLoading.label.text = "连接失败，请检测网络或联系开发者"
	await get_tree().create_timer(1).timeout
	SceneLoading.stop_show()	

func delete_save(archive):
	if current_delete_archive == null:
		confirmation_delete_dialog.popup()
		confirmation_delete_dialog.dialog_text = '是否删除确认删除存档: ' + archive
		current_delete_archive = archive

func _on_create_archive_button_pressed() -> void:
	SaveManager.save_game("存档"+str(len(SaveManager.get_save_list()) +1), {})
	update_list()

func _on_confirmation_delete_dialog_confirmed() -> void:
	SaveManager.delete_save(current_delete_archive)
	current_delete_archive = null
	update_list()	

func _on_confirmation_delete_dialog_canceled() -> void:
	current_delete_archive = null
