class_name AdditionalCompositeArea extends Area2D

@export var compositer:Compositer

var additional = {}

func _on_area_entered(area: Area2D) -> void:
	if area is AdditionalComposite:
		additional[area.title] = area.composites
		compositer.update_composite_list()

func _on_area_exited(area: Area2D) -> void:
	if area is AdditionalComposite:
		additional.erase(area.title)
		compositer.update_composite_list()
