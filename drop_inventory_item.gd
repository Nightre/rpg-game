class_name DropInventoryItem extends DropItem

var item:InventoryItem
var num = 1

@export var pick_manager:PickManager

func _ready() -> void:
	super._ready()
	sprite_2d.texture = item.get_texture()

func pick():
	pick_manager.pick(item, num)
