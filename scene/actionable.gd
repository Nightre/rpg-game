class_name ActionAble extends Area2D
signal interacted
@onready var action_tip: Sprite2D = $ActionTip

var active = false

func _ready() -> void:
	set_active(false)

func set_active(new_active):
	active = new_active
	action_tip.visible = active
		
func interact():
	interacted.emit()
	
