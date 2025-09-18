extends ColorRect

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_quest_manager_quest_completed(id: String) -> void:
	var quest = Data.quest[id]
	label.text = "任务完成：" + str(quest.title)
	animation_player.play("show")

func _on_quest_manager_quest_accepted(id: String) -> void:
	var quest = Data.quest[id]
	label.text = "接受任务：" + str(quest.title)
	animation_player.play("show")
