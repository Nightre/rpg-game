class_name QuestManager
extends Node

# 任务状态枚举
enum QuestState {
	ONGOING,
	COMPLETED,
	FAILED,
	CANCELLED,
}
signal quest_completed(id: String)
signal quest_accepted(id: String)

# 当前动态任务状态字典
# quests = {
#     "quest_id": {
#         "status": QuestState,
#         "progress": int,
#         "gui_instance": Control
#     }
# }
var quests: Dictionary[String, Dictionary] = {}

# 存储已完成和已接受任务的列表
var completed_quests: Array[String] = []
var accepted_quests: Array[String] = []

@export var gui_container: VBoxContainer

func _ready() -> void:
	pass#add_quest("get_kunkun")

# 给任务（添加新任务）
func add_quest(id: String) -> void:
	if not id in Data.quest:
		push_warning("Quest ID %s not found in Data.quest" % id)
		return

	if id in quests:
		# 如果任务已存在，直接忽略
		return

	# 记录任务已被接受
	if not accepted_quests.has(id):
		accepted_quests.append(id)

	var quest_data = Data.quest[id]

	# 创建 UI 节点
	var gui_instance = create_gui_instance(quest_data)
	gui_container.add_child(gui_instance)

	quests[id] = {
		"status": QuestState.ONGOING,
		"progress": 0,
		"gui_instance": gui_instance
	}

	quest_accepted.emit(id)

# 完成任务
func complete_quest(id: String) -> void:
	if id in quests:
		quests[id]["status"] = QuestState.COMPLETED
		# 记录任务已完成
		if not completed_quests.has(id):
			completed_quests.append(id)
		# 移除任务
		remove_quest(id)
		quest_completed.emit(id)

# 取消任务
func cancel_quest(id: String) -> void:
	if id in quests:
		quests[id]["status"] = QuestState.CANCELLED
		# 移除任务
		remove_quest(id)

# 任务失败
func fail_quest(id: String) -> void:
	if id in quests:
		quests[id]["status"] = QuestState.FAILED
		# 移除任务
		remove_quest(id)

# 判断任务是否存在
func has_quest(id: String) -> bool:
	return id in quests

# 获取任务状态
func get_quest_status(id: String) -> int:
	if id in quests:
		return quests[id]["status"]
	return -1 # 无效状态

# 移除任务（清理 GUI 和状态）
func remove_quest(id: String) -> void:
	if id in quests:
		var gui_instance = quests[id]["gui_instance"]
		if gui_instance != null and is_instance_valid(gui_instance):
			gui_instance.queue_free()
		quests.erase(id)

# 清空所有任务 UI 和状态
func remove_all() -> void:
	for child in gui_container.get_children():
		child.queue_free()
	quests.clear()

# 内部方法：创建任务 UI
func create_gui_instance(quest_data: QuestData) -> Control:
	var instance = preload("res://scene/ui/quest_info.tscn").instantiate()
	instance.quest = quest_data
	return instance

# 新增功能: 判断任务是否已完成
func is_quest_completed(id: String) -> bool:
	return completed_quests.has(id)

# 新增功能: 判断任务是否已接受（不管是否完成或取消）
func is_quest_accepted(id: String) -> bool:
	return accepted_quests.has(id)
