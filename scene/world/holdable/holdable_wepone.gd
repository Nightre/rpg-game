class_name HoldableWepone extends Holdable

signal charge_completed

@export var charge_rate: float = 0.0
@export var bullet: PackedScene
@export var sprite_frame_num: int = 0  # 蓄力总帧数（0~N-1）
@export var consume:String
@export var team = ""
@onready var hit_box: HitArea = %HitBox

var sender:Entity
var direction:Vector2=Vector2.ZERO
var charging := false
var charge_time := 0.0

func _ready() -> void:
	hit_box.team = team

func can_use():
	if not compositer:
		return true
	if not consume:
		return true
	return compositer.get_item_quantity(consume) > 0

func _process(delta: float) -> void:
	rotation = direction.angle()
	if charging and charge_rate > 0:
		charge_time = min(charge_time + delta, charge_rate) 
		update_charge_style()
		if charge_time >= charge_rate:
			charge_completed.emit()
			
func update_charge_style():
	if charge_rate > 0 and sprite_frame_num > 0:
		var ratio = clamp(charge_time / charge_rate, 0.0, 1.0)
		var frame_index = int(ratio * (sprite_frame_num - 1))
		sprite_2d.frame = frame_index

func start_use() -> void:
	if charge_rate > 0:
		charging = true
		charge_time = 0.0
		update_charge_style()
	else:
		charge_completed.emit()
		use(1.0) # 无蓄力时直接满威力

func end_use() -> void:
	if charge_rate > 0 and charging:
		if consume and compositer:
			compositer.remove_items_by_prototype(consume, 1)
		charging = false
		var charge_ratio = charge_time / charge_rate
		charge_ratio = clamp(charge_ratio, 0.0, 1.0)
		use(charge_ratio)
	sprite_2d.frame = 0

func use(ratio: float=1.0) -> void:
	if animation_player.has_animation("use"):
		animation_player.play("use")

	if bullet:
		var b = bullet.instantiate()
		b.team = team
		b.direction = direction
		b.global_position = global_position
		b.rotation = rotation
		b.sender = sender

		b.speed *= lerp(1.0, 2.0, ratio) 
		get_tree().current_scene.add_child(b)
	if use_cold_time > 0:
		await get_tree().create_timer(use_cold_time).timeout
	used.emit()
