class_name BuildableInteractionManager extends Node

@export var hud:HUD

@export var buildable_hud_root:Control
@onready var name_label: Label = $"../Panel/NameLabel"

var buildable_hud:Control
var buildable:Buildable

func _init() -> void:
	Global.buildable_interaction_manager = self

func open_buildable(new_buildable:Buildable):
	buildable = new_buildable
	hud.open_hud(hud.HUD_TYPE.BUILDABLE)
	hud.open_hud(hud.HUD_TYPE.INVENTORY)

	buildable_hud = buildable.create_hud()
	buildable_hud_root.add_child(buildable_hud)
	name_label.text = buildable.title
