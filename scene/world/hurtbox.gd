class_name Hurtbox extends Area2D
signal damaged(damage)

@export var team = ""

func _on_area_entered(area: Area2D) -> void:
	if area is HitArea and area.team != team:
		damaged.emit(area.damage)
