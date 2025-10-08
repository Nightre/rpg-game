extends Control

@onready var help_dialog: AcceptDialog = %HelpDialog
@onready var setting_dialog: AcceptDialog = %SettingDialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mutiplayer_dialog: Window = %MutiplayerDialog
@onready var user_name_line_edit: LineEdit = %UserNameLineEdit
@onready var server_ip_line_edit: LineEdit = %ServerIpLineEdit
@onready var archive_list: VBoxContainer = $Archive/ArchiveList

func _ready() -> void:
	user_name_line_edit.text = "用户名" + str(randi_range(100, 999))

func _on_start_button_pressed() -> void:
	animation_player.play("open_archive")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_help_button_pressed() -> void:
	help_dialog.popup()

func _on_setting_button_pressed() -> void:
	setting_dialog.popup()

func _on_go_main_button_pressed() -> void:
	animation_player.play("close_archive")

func _on_muti_player_button_pressed() -> void:
	mutiplayer_dialog.popup()

func _on_create_server_button_pressed() -> void:
	Online.online_type = Online.ONLINE_TYPE.SERVER
	animation_player.play("open_archive")
	mutiplayer_dialog.hide()
	init_online()

func _on_mutiplayer_dialog_close_requested() -> void:
	mutiplayer_dialog.hide()

func init_online():
	Online.player_info["name"] = user_name_line_edit.text


func _on_join_server_button_pressed() -> void:
	init_online()
	mutiplayer_dialog.hide()
	Online.online_type = Online.ONLINE_TYPE.CLIENT
	Online.server_ip = server_ip_line_edit.text
	archive_list.start_game()
