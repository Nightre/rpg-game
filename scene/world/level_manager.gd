class_name LevelManager
extends Node

signal level_load_started(level_name: String)
signal level_changed(level_name: String)

@onready var map: Node2D = $"../Map"
@export var keep_node:Array[Node] = []
@export var init_scene:String
@onready var player: Player = $"../Player"
@onready var build_manager: BuildManager = $"../BuildManager"

var loading_path = null
var current_path = null
var level:Node2D
# path: [BuildingData]
var level_buildings:Dictionary = {}

func save_scene():
	level_buildings[current_path] = []
	for node in get_tree().get_nodes_in_group("Buildables"):
		var data = {
			"scene": node.get_scene_file_path(),
			"data": node.serialize()
		}
		level_buildings[current_path].append(data)
		node.queue_free()

func load_scene():
	if current_path in level_buildings:
		for data in level_buildings[current_path]:
			var i = (load(data["scene"]) as PackedScene).instantiate()
			i.deserialize(data["data"])
			level.add_child(i)

func _init() -> void:
	Global.level_manager = self

func _ready() -> void:
	call_deferred("change_to_level", init_scene)

func change_to_level(path: String) -> void:
	save_scene()
	level_load_started.emit(path)
	ResourceLoader.load_threaded_request(path)
	loading_path = path
	
	if level:
		for k in keep_node:
			k.reparent(get_tree().root)
		for k in get_tree().get_nodes_in_group("scene_owen"):
			k.queue_free()
		level.queue_free()
		level = null
		
func _process(delta: float):
	if not loading_path:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_path, progress)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		level_changed.emit(loading_path)
		
		level = (ResourceLoader.load_threaded_get(loading_path) as PackedScene).instantiate()
		map.add_child(level)
		for k in keep_node:
			k.reparent(level)
		player.position = level.get_player_pos()
		current_path = loading_path
		load_scene()
