extends Area2D
signal interacted(actionable:ActionAble)

var current_actionable:ActionAble

func _process(delta: float) -> void:
	var min:ActionAble = null
	var min_dis = INF
	for actionable in get_overlapping_areas():
		var new_dis = actionable.global_position.distance_to(global_position)
		if new_dis < min_dis:
			min_dis = new_dis
			min = actionable
			
	set_current_actionable(min)

func set_current_actionable(actionable):
	if actionable == current_actionable:
		return
		
	if current_actionable:
		current_actionable.set_active(false)
	if actionable:
		current_actionable = actionable
		current_actionable.set_active(true)
		
func _on_area_exited(area: Area2D) -> void:
	if area == current_actionable:
		current_actionable.set_active(false)
		current_actionable = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and current_actionable:
		interacted.emit(current_actionable)
		current_actionable.interact()
