class_name HurtLable extends Control
@onready var hurt_lable: Label = $HurtLable
var text = ""

func _ready() -> void:
	hurt_lable.text =text
