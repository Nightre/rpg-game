extends Button

@export var quest:QuestData
@onready var window: Window = $Window
@onready var label: Label = $Window/Label

func _ready() -> void:
	text = quest.title
	window.title = quest.title
	label.text = quest.description


func _on_pressed() -> void:
	window.popup()
