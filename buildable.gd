class_name Buildable extends Node2D
@onready var place_area_2d: Area2D = $PlaceArea2D
@onready var collision_shape_2d_2: CollisionShape2D = $PlaceArea2D/CollisionShape2D2
@onready var sprite_2d: Sprite2D = $Sprite2D

var in_build = false
var can_build = false

func set_in_build(is_in_build):
	in_build = is_in_build
	collision_shape_2d_2.disabled = !in_build
	if in_build:
		set_can_build(true)
	else:
		sprite_2d.modulate = Color.WHITE

func set_can_build(value: bool) -> void:
	can_build = value
	if can_build:
		sprite_2d.modulate = Color(0, 1, 0, 0.7)
	else:
		sprite_2d.modulate = Color(1, 0, 0, 0.7)

func _on_place_area_2d_body_entered(body: Node2D) -> void:
	if in_build:
		set_can_build(false)

func _on_place_area_2d_body_exited(body: Node2D) -> void:
	if in_build and len(place_area_2d.get_overlapping_bodies()) == 0:
		set_can_build(true)
