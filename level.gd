extends Node2D
@onready var player_position: Marker2D = $PlayerPosition

func get_player_pos():
	return player_position.position
