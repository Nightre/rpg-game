class_name DropItem extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

#var item:InventoryItem
#var num = 1

var target:Player
var disable_time = 0
var disabled = false

const SPEED = 100.0

func _ready() -> void:
	if disable_time > 0:
		disabled = true
		timer.wait_time = disable_time
		timer.start()
	#sprite_2d.texture = item.get_texture()

func set_taget(new_target:Player):
	target = new_target
	
func _process(delta: float) -> void:
	if target and not disabled:
		global_position = global_position.move_toward(target.global_position, delta * SPEED)
		if (global_position - target.global_position).length() < 10.0:
			#pick_manager.pick(item, num)
			#queue_free()
			pick()
			queue_free()

func pick():
	pass

func _on_timer_timeout() -> void:
	disabled = false
