extends Control

@onready var help_dialog: AcceptDialog = %HelpDialog
@onready var setting_dialog: AcceptDialog = %SettingDialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var archive_list: VBoxContainer = $Archive/ArchiveList

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
