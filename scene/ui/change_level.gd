extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_level_manager_level_load_started(level_name: String) -> void:
	animation_player.play("show")


func _on_level_manager_level_changed(level_name: String) -> void:
	animation_player.play("hide")
