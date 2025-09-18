class_name LevelManager
extends Node

signal level_load_started(level_name: String)
signal level_changed(level_name: String)

var loading_path = null

func change_to_level(path: String) -> void:
	level_load_started.emit(path)
	ResourceLoader.load_threaded_request(path)
	loading_path = path
	
func _process(delta: float):
	if not loading_path:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_path, progress)

	#if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		#progress_value = progress[0] * 100
		#progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		level_changed.emit(loading_path)
