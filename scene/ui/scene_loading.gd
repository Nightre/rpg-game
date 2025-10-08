extends CanvasLayer

signal scene_loaded(resource: Resource)

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var label: Label = $ColorRect/Label

var path: String
var in_loading = false

func _ready() -> void:
	hide()

func start_show():
	if in_loading:
		return false
	
	animation_player.play("loadstart")
	show()
	await animation_player.animation_finished

func stop_show():
	animation_player.play("loadover")
	
	await animation_player.animation_finished
	hide()
	in_loading = false

func load_scene(path_to_load: String):
	if in_loading:
		return false
	in_loading = true
	path = path_to_load
	
	if visible == false:
		start_show()
	label.text = "加载资源中..."
	
	ResourceLoader.load_threaded_request(path)
	var resource = await scene_loaded
	get_tree().change_scene_to_packed(resource)
	get_tree().paused = false

	await stop_show()
	return true

func _process(delta: float):
	if not path:
		return
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		scene_loaded.emit(ResourceLoader.load_threaded_get(path))
