class_name World extends Node2D
@onready var spawner: MultiplayerSpawner = $PlayerMultiplayerSpawner
const PLAYER = preload("res://scene/world/player.tscn")
	
func add_player(pid, player_info):
	var node = PLAYER.instantiate()
	add_child(node)
	return node
