class_name Game extends Node

@export var player:Player
@onready var world: World = $World
@onready var hud: HUD = $CanvasLayer/HUD

func _init() -> void:
	Global.current_game = self
	
