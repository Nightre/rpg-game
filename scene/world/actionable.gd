class_name ActionAble extends Area2D
signal interacted

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var action_tip: Sprite2D = $ActionTip
@export var time: float = 1.0 
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var active: bool = false
var hold_time: float = 0.0
var is_holding: bool = false
			
func _ready() -> void:
	set_active(false)
	progress_bar.max_value = time
	progress_bar.value = 0
	progress_bar.visible = false

func _process(delta: float) -> void:
	if is_holding and active:
		hold_time += delta
		progress_bar.value = hold_time
		if hold_time >= time:
			interact()
			reset_interaction()

func interact():
	interacted.emit()

func set_active(new_active: bool) -> void:
	active = new_active
	action_tip.visible = active
	if not active:
		reset_interaction()

func interact_pressed() -> void:
	if active:
		is_holding = true
		progress_bar.visible = true
		action_tip.hide()

func interact_released() -> void:
	if active:
		action_tip.show()
		reset_interaction()

func reset_interaction() -> void:
	is_holding = false
	hold_time = 0.0
	progress_bar.value = 0
	progress_bar.visible = false
