extends TextureButton

@onready var label: Label = $Label

@export var place_id = ""
@export var place_name = ""
@export var place_describe = ""

func _ready() -> void:
	label.text = place_name
