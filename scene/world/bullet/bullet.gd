class_name Bullet extends Node2D

@export var speed = 100.0
@export var life_time = 10
@onready var timer: Timer = $Timer
@onready var bullet: Sprite2D = $Bullet
@export var team:String
@onready var hit_area_2d: HitArea = $HitArea2D
@onready var line_2d: Line2D = $Line2D
@onready var hurt_particles_2d: GPUParticles2D = $HurtParticles2D
@onready var collision_shape_2d: CollisionShape2D = $HitArea2D/CollisionShape2D

var sender:Entity
var is_active = true

func _ready() -> void:
	hit_area_2d.team = team
	timer.wait_time = life_time
	timer.start()
	
func _process(delta: float) -> void:
	if is_active:
		position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_timer_timeout() -> void:
	die()
	
func die():
	bullet.hide()
	is_active = false
	collision_shape_2d.disabled = true
	queue_free()

func _on_die_area_2d_body_entered(body: Node2D) -> void:
	if body != sender:
		die()
