class_name Bullet extends Node2D

@export var speed = 100.0
@export var life_time = 10
@onready var timer: Timer = $Timer
@export var direction:Vector2
@onready var bullet: Sprite2D = $Bullet

func _ready() -> void:
	timer.wait_time = life_time
	if direction.length() == 0:
		direction = Vector2.RIGHT.rotated(rotation)
	bullet.rotation = direction.angle()
	timer.start()
	
func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
