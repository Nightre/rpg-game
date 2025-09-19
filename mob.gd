extends Entity

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var healthbar: TextureProgressBar = $Healthbar
@onready var held_item_manager: HandManager = $HeldItemManager
@onready var attack_timer: Timer = $AttackTimer
@onready var player: Sprite2D = $Player
@onready var hand: Node2D = $Player/Hand

@export var max_hp: float = 100.0
@export var hp: float = max_hp:
	set(value):
		hp = clampf(value, 0.0, max_hp)
		if healthbar:
			healthbar.value = (hp / max_hp) * 100.0
		if hp <= 0:
			print("_hp", hp)
			change_state("die")
	get:
		return hp
@export var max_path_length: float = 300.0  # 最大路径长度
@export var hand_item = ""

var state: String 

func _ready() -> void:
	hp = max_hp
	change_state("idle")
	
	if hand_item:
		held_item_manager.equip(hand_item)

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	match state:
		"walk":
			var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
			velocity = dir * speed
			player.scale.x = 1 if dir.x > 0 else -1
		"idle":
			pass
		"die":
			pass
	move_and_slide()

func make_path() -> void:
	var target = Global.player
	navigation_agent_2d.target_position = target.global_position
	var path_length = navigation_agent_2d.distance_to_target()
	if path_length > max_path_length and state == "walk":
		target = null
		change_state("idle")
	elif state == "idle":
		change_state("walk")
		
func _on_navigation_timer_timeout() -> void:
	make_path()

func _on_hurtbox_damaged(damage: Variant) -> void:
	hp -= damage

# ---------------- 状态管理 ----------------
func change_state(new_state: String) -> void:
	if state == new_state:
		return
	#print("change_state:", state, " -> ", new_state)
	var prev = state
	state = new_state
	on_state_changed(prev, state)

func on_state_changed(from: String, to: String) -> void:
	match to:
		"die":
			queue_free()
		"attack":
			attack()
			attack_timer.start()
	
	attack_timer.paused = to != "attack"

func _on_attackable_area_body_entered(body: Entity) -> void:
	if body is Entity and body.team != team:
		change_state("attack")

func _on_attackable_area_body_exited(body: Entity) -> void:
	if body is Entity and body.team != team:
		change_state("idle")

func _on_attack_timer_timeout() -> void:
	attack()

func attack():
	if held_item_manager.hand_node:
		var hand_node = held_item_manager.hand_node
		if hand_node and hand_node is HoldableWepone and hand_node.can_use():
			held_item_manager.start_use()
			await hand_node.charge_completed
			
			# 计算玩家与武器的距离
			var distance = hand_node.global_position.distance_to(Global.player.global_position)
			
			# 假设炮弹速度（像素/秒）
			var bullet_speed = 600.0  # 根据你的游戏调整这个值
			
			# 计算炮弹飞行时间
			var time_to_target = distance / bullet_speed
			
			# 预测玩家位置
			var target_pos = Global.player.global_position + Global.player.velocity * time_to_target
			
			# 计算方向
			var dir = (target_pos + Vector2(0, -12)) - hand_node.global_position
			held_item_manager.set_direction(dir.normalized())
			held_item_manager.end_use()
