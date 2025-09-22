class_name TechTreeNode extends Button

@export var tech_tree_manager: TechTreeManager
@export var id: String

@onready var unable_unlock: TextureRect = $UnableUnlock
@onready var unlocked: TextureRect = $Unlocked

var data: TechNodeData
var is_locked: bool = true  # 节点本身是否锁定（未解锁）
var prerequisites_met: bool = false  # 前置条件是否全部满足

func _ready() -> void:
	_initialize_node()
	_connect_signals()
	update_visual_state()

func _initialize_node() -> void:
	data = Data.tech_nodes[id]
	text = data.title
	# 初始化时检查前置条件
	prerequisites_met = tech_tree_manager.is_prerequisites_unlocked(data)
	is_locked = true  # 默认所有节点都是锁定的

func _connect_signals() -> void:
	tech_tree_manager.node_locked.connect(_on_node_locked)
	tech_tree_manager.node_unlocked.connect(_on_node_unlocked)

func update_visual_state() -> void:
	prerequisites_met = tech_tree_manager.is_prerequisites_unlocked(data)
	# 隐藏所有状态图标
	unable_unlock.visible = false
	unlocked.visible = false
	
	# 根据独立的状态显示对应图标
	if not is_locked:
		unlocked.visible = true  # 自己已解锁
	elif not prerequisites_met:
		unable_unlock.visible = true  # 前置未全部解锁
	# 其他情况（前置已解锁但自己未解锁），不显示任何图标

func _on_node_locked(tid: String) -> void:
	if tid == id:
		is_locked = true
	update_visual_state()

func _on_node_unlocked(tid: String) -> void:
	if tid == id:
		is_locked = false
	update_visual_state()

func get_center() -> Vector2:
	return position + size / 4

func init_lines() -> void:
	for pre in data.prerequisites:
		var pre_node = tech_tree_manager.tree_nodes[pre]
		var line = Line2D.new()
		line.add_point(get_center())
		line.add_point(pre_node.get_center())
		line.width = 3
		get_parent().add_child.call_deferred(line)

# 公共接口：检查节点状态
func can_be_unlocked() -> bool:
	return prerequisites_met and is_locked  # 前置满足且自己未解锁

func is_unlocked() -> bool:
	return not is_locked

func are_prerequisites_met() -> bool:
	return prerequisites_met
