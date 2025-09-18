class_name DropCoin extends DropItem

@export var player_info:PlayerInfo
@export var num = 1

func pick():
	player_info.money += num
