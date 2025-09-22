extends Buildable

@onready var watering_area_2d: Area2D = $WateringArea2D

func _on_water_timer_timeout() -> void:
	if not in_build:
		for area in watering_area_2d.get_overlapping_areas():
			if area.get_parent() is FieldBuildable:
				var field = area.get_parent() as FieldBuildable
				field.watering(2.5)
