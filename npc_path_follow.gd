extends Node2D

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
var dir = 1
var speed = 50

func _process(delta: float) -> void:
	path_follow_2d.progress += dir * speed * delta

func _on_timer_timeout() -> void:
	var pool = [-1, -1, 0, 1, 1]
	dir = pool.pick_random()
