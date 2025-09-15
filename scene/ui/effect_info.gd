extends Panel

var effect_data:EffectData
@onready var name_label: Label = $NameLabel
@onready var time_label: Label = $TimeLabel
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture = effect_data.image
	name_label.text = effect_data.effect_name

func update_time(time):
	time_label.text = "剩余 %.f 秒" % time
