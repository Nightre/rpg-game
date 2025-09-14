class_name Player extends Entity

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right","move_up","move_down")
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()
