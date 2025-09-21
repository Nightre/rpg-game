class_name UseArea extends Area2D

var current_buildable:Buildable

func _process(delta: float) -> void:
	var min:Buildable = null
	var min_dis = INF
	for actionable in get_overlapping_areas():
		var new_dis = actionable.global_position.distance_to(global_position)
		if new_dis < min_dis:
			min_dis = new_dis
			min = actionable.get_parent()
	set_current_buildable(min)

func set_current_buildable(buildable):
	if buildable == current_buildable:
		return
	current_buildable = buildable
