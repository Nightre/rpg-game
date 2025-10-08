extends Control

@onready var map: Sprite2D = $Map
@onready var map_container: Control = $MapContainer  # 需要在场景中添加一个Control节点作为容器
@onready var title_label: Label = $Panel/TitleLabel
@onready var rich_text_label: RichTextLabel = $Panel/RichTextLabel
@onready var player_position: TextureRect = $Map/PlayerPosition

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var panel_width = 256.0
var way_points = {}

func _ready() -> void:
	visible = false
	for child in get_tree().get_nodes_in_group("way_point"):
		child.pressed.connect(func (): on_way_point_pressed(child))
		way_points[child.place_id] = child

func on_way_point_pressed(way_point):
	if way_point:
		title_label.text = way_point.place_name
		rich_text_label.text = way_point.place_describe
	else:
		title_label.text = ""
		rich_text_label.text = ""

func update_player_pos():
	var current_pos = Global.level_manager.current_pos
	player_position.global_position = (way_points[current_pos] as Control).global_position
	player_position.global_position -= Vector2(36, 57)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		visible = !visible
		get_tree().paused = visible
		update_player_pos()

	if not visible:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# 开始拖动
				is_dragging = true
				drag_offset = map.global_position - get_global_mouse_position()
			else:
				# 结束拖动
				is_dragging = false
	
	elif event is InputEventMouseMotion and is_dragging:
		# 计算新的位置
		var new_position = get_global_mouse_position() + drag_offset
		# 限制在窗口内
		new_position = clamp_position(new_position)
		# 更新地图位置
		map.global_position = new_position

func clamp_position(position: Vector2) -> Vector2:
	# 获取窗口大小
	var window_size = get_viewport().get_visible_rect().size
	window_size.x -= panel_width
	
	# 获取地图的尺寸
	var map_texture_size = map.get_texture().get_size() * map.scale
	var map_rect = Rect2(position, map_texture_size)
	
	# 限制地图不能完全移出窗口
	var clamped_position = position
	
	# 左边界
	if map_rect.position.x > 0:
		clamped_position.x = 0
	elif map_rect.end.x < window_size.x:
		clamped_position.x = window_size.x - map_rect.size.x
	
	# 上边界
	if map_rect.position.y > 0:
		clamped_position.y = 0
	elif map_rect.end.y < window_size.y:
		clamped_position.y = window_size.y - map_rect.size.y
	
	return clamped_position
