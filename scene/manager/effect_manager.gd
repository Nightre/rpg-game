class_name EffectManager extends Node

# 效果数据：键是效果 ID，值是 {time: 剩余时间, gui_instance: GUI 节点}
var effects: Dictionary[String, Dictionary] = {}

@export var gui_container: VBoxContainer

func give_effect(id: String) -> void:
	if id in Data.effect:
		var effect_data = Data.effect[id]

		# 如果已经有这个效果，就直接增加时间
		if id in effects:
			effects[id]["time"] += effect_data["effect_time"]
			return

		# 否则新建 GUI 节点
		var gui_instance = create_gui_instance(effect_data)
		effects[id] = {
			"time": effect_data["effect_time"],
			"gui_instance": gui_instance
		}
		gui_container.add_child(gui_instance)
	else:
		push_warning("Effect ID %s not found in Data.effect" % id)


func remove_effect(id: String) -> void:
	if id in effects:
		var effect = effects[id]
		if effect["gui_instance"] != null and is_instance_valid(effect["gui_instance"]):
			effect["gui_instance"].queue_free()
		effects.erase(id)

func _process(delta: float) -> void:
	var to_remove: Array[String] = []
	for id in effects:
		var effect = effects[id]
		effect["time"] -= delta 
		if effect["gui_instance"] != null and is_instance_valid(effect["gui_instance"]):
			effect["gui_instance"].update_time(effect["time"])
		if effect["time"] <= 0:
			to_remove.append(id)
	
	for id in to_remove:
		remove_effect(id)

func create_gui_instance(effect_data) -> Control:
	var container = preload("res://scene/ui/effect_info.tscn").instantiate()
	container.effect_data = effect_data
	
	return container

func has_effect(id:String):
	return id in effects
