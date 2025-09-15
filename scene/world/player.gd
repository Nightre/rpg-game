class_name Player extends Entity
@onready var effect_manager: EffectManager = $EffectManager

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right","move_up","move_down")
	var final_speed = speed + 100 if effect_manager.has_effect("speed") else speed
	if direction:
		velocity = direction * final_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()
