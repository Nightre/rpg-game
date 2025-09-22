class_name Holdable extends Node2D

signal used
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var use_cold_time = 0
@export var compositer:Compositer
@export var image:Texture2D
@onready var sprite_2d: Sprite2D = $"Povit/Sprite2D"
@onready var povit: Node2D = $Povit

func _ready() -> void:
	sprite_2d.texture = image

func start_use():
	use()
	
func use():
	animation_player.play("use")
	if use_cold_time > 0:
		await get_tree().create_timer(use_cold_time).timeout
	used.emit()

func set_povit_dir(new_rotation):
	povit.rotation = new_rotation + PI/4

func _physics_process(delta):
	povit.position.y = sin(Time.get_ticks_msec() * delta * 0.2) * 3

func end_use():
	pass

func can_use():
	pass
