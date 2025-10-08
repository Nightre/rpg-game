# SaveSystem.gd
# Godot存档系统 - 使用正确的DirAccess API
# 添加到AutoLoad作为单例

extends Node

const SAVE_DIR = "user://saves/"

func _ready():
	# 确保存档目录存在
	_create_save_directory()

# 创建存档目录（如果不存在）
func _create_save_directory() -> void:
	var error = DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	if error != OK:
		print("创建存档目录失败: ", SAVE_DIR, " 错误代码: ", error)
	else:
		print("存档目录已准备就绪: ", SAVE_DIR)

# 创建存档
func save_game(save_name: String, data: Dictionary) -> bool:
	if save_name.is_empty():
		print("错误: 存档名称不能为空")
		return false
	
	var file_path = SAVE_DIR + save_name + ".json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file == null:
		var error = FileAccess.get_open_error()
		print("打开文件写入失败: ", file_path, " 错误: ", error)
		return false
	
	var json_string = JSON.stringify(data, "  ", false)
	file.store_string(json_string)
	file.close()
	
	print("存档成功: ", save_name)
	return true

# 读取存档
func load_game(save_name: String) -> Dictionary:
	if save_name.is_empty():
		print("错误: 存档名称不能为空")
		return {}
	
	var file_path = SAVE_DIR + save_name + ".json"
	
	if not FileAccess.file_exists(file_path):
		print("存档文件不存在: ", file_path)
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		print("打开文件读取失败: ", file_path, " 错误: ", error)
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("JSON解析错误: ", json.get_error_line(), " - ", json.get_error_message())
		return {}
	
	var parsed_data = json.data
	if typeof(parsed_data) != TYPE_DICTIONARY:
		print("存档数据不是字典类型")
		return {}
	
	print("加载存档成功: ", save_name)
	return parsed_data

# 获取所有存档列表
func get_save_list() -> PackedStringArray:
	var save_list: PackedStringArray = []
	
	# 检查目录是否存在
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		print("存档目录不存在: ", SAVE_DIR)
		return save_list
	
	# 获取目录中所有文件
	var files = DirAccess.get_files_at(SAVE_DIR)
	
	# 过滤出.json文件
	for file_name in files:
		if file_name.ends_with(".json"):
			var save_name = file_name.replace(".json", "")
			save_list.append(save_name)
	
	# 按名称排序
	save_list.sort()
	
	print("找到 ", save_list.size(), " 个存档: ", save_list)
	return save_list

# 删除指定存档
func delete_save(save_name: String) -> bool:
	if save_name.is_empty():
		print("错误: 存档名称不能为空")
		return false
	
	var file_path = SAVE_DIR + save_name + ".json"
	
	if not FileAccess.file_exists(file_path):
		print("要删除的存档不存在: ", save_name)
		return false
	
	var error = DirAccess.remove_absolute(file_path)
	if error != OK:
		print("删除存档失败: ", save_name, " 错误代码: ", error)
		return false
	
	print("删除存档成功: ", save_name)
	return true

# 检查存档是否存在
func save_exists(save_name: String) -> bool:
	var file_path = SAVE_DIR + save_name + ".json"
	return FileAccess.file_exists(file_path)

# 获取存档文件完整路径（用于调试）
func get_save_path(save_name: String) -> String:
	return SAVE_DIR + save_name + ".json"

# 获取存档目录完整路径
func get_save_directory() -> String:
	return SAVE_DIR

func save_current():
	if not Global.current_archive:
		return
	var data = serlize_game()
	save_game(Global.current_archive["archive"], data)
	
func serlize_game():
	return {}
