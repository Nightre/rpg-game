class_name Entity extends CharacterBody2D

signal hp_changed(hp)

var is_alive = true

@export var speed = 300.0
@export var team = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurt_particle: GPUParticles2D = $HurtParticle
@onready var healthbar: TextureProgressBar = $Healthbar
@onready var hand_node: Node2D = $HandNode
@onready var player: Sprite2D = $Player
@onready var hurt_label_marker_2d: Marker2D = $HurtLabelMarker2D
@export var point_color:Color = Color.WHITE
@export var max_hp: float = 100.0
@export var hp: float = max_hp:
	set(value):
		hp = clampf(value, 0.0, max_hp)
		if healthbar:
			healthbar.value = (hp / max_hp) * 100.0
		if hp <= 0:
			die()
		hp_changed.emit(hp)
	get:
		return hp
var knockback = Vector2.ZERO

func _ready() -> void:
	hurtbox.team = team
	hp = max_hp
	
	player.material = ShaderMaterial.new()
	player.material.shader = preload("res://scene/world/entity/Entity.gdshader")
	player.set_instance_shader_parameter("active", false)

func _on_hurtbox_damaged(damage: Variant, area:HitArea) -> void:
	if not is_alive:
		return
	var knockback_strength = 5
	hurt_particle.rotation = (global_position - area.global_position).angle()
	animation_player.play("hurt")

	var knockback_dir = (global_position - area.global_position).normalized()
	knockback = knockback_dir * knockback_strength
	
	hp -= damage
	if hp > 0:
		var hurt_label = preload("res://scene/ui/hurt_lable.tscn").instantiate()
		hurt_label.text = str(-damage)
		get_parent().add_child(hurt_label)
		hurt_label.global_position = hurt_label_marker_2d.global_position

func _physics_process(delta: float) -> void:
	position += knockback
	knockback *= 0.9

func hand_look_at(target_position:Vector2):
	if target_position.x - global_position.x < 0:
		hand_node.position.x = -15
		#hand_node.sprite_2d.flip_v = true
		player.flip_h = true
	else:
		hand_node.position.x = 15
		#hand_node.sprite_2d.flip_v = false
		player.flip_h = false

func die():
	is_alive = false
