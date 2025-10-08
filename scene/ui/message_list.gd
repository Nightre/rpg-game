extends VBoxContainer

func _ready() -> void:
	Online.player_connected.connect(on_player_connected)
	Online.player_disconnected.connect(on_player_disconnected)

func add_message(text):
	var label = Label.new()
	label.text = text
	add_child(label)
	
	if get_child_count() > 10:
		get_child(0).queue_free()

func on_player_connected(peer_id, player_info):
	add_message("<"+player_info["name"]+"> 加入了游戏")

func on_player_disconnected(peer_id, player_info):
	add_message("<"+player_info["name"]+"> 离开了游戏")
	
