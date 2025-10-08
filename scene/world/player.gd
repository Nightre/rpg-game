class_name Player extends Entity

@export var effect_manager: EffectManager
@export var held_item_manager: HandManager

func _init() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	super(delta)
	
	var direction := Input.get_vector("move_left", "move_right","move_up","move_down")
	var final_speed = speed + 100 if effect_manager.has_effect("speed") else speed
	if direction:
		velocity = direction * final_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	var mouse_position = get_global_mouse_position()
	move_and_slide()

func _process(delta: float) -> void:
	if is_multiplayer_authority():
		var hand_node = held_item_manager.hand_node
		hand_look_at(get_global_mouse_position())
		if hand_node:
			held_item_manager.hand_look_at(get_global_mouse_position())

func _on_pick_area_area_entered(area: Area2D) -> void:
	if area is DropItem:
		area.set_taget(self)

func _on_pick_area_area_exited(area: Area2D) -> void:
	if area is DropItem:
		area.set_taget(null)
		
func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("use"):
			held_item_manager.start_use()
			
		if Input.is_action_just_released("use"):
			held_item_manager.end_use()
	
