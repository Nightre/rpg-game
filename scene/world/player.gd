class_name Player extends Entity
@onready var effect_manager: EffectManager = $EffectManager
@onready var player: Sprite2D = $Player
@onready var held_item_manager: HandManager = $HeldItemManager

func _init() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right","move_up","move_down")
	var final_speed = speed + 100 if effect_manager.has_effect("speed") else speed
	if direction:
		velocity = direction * final_speed
		if direction.x != 0:
			player.scale.x = 1 if direction.x > 0 else -1
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()


func _on_pick_area_area_entered(area: Area2D) -> void:
	if area is DropItem:
		area.set_taget(self)

func _on_pick_area_area_exited(area: Area2D) -> void:
	if area is DropItem:
		area.set_taget(null)
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use"):
		held_item_manager.start_use()
		
	if Input.is_action_just_released("use"):
		held_item_manager.end_use()
	
