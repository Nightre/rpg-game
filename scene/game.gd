class_name Game extends Node

@export var player:Player
@onready var hud: HUD = %HUD
@onready var inventory: Inventory = $CanvasLayer/HUD/InventoryContainer/Inventory/Inventory
@onready var world: World = $World

func _init() -> void:
	Global.current_game = self
	
