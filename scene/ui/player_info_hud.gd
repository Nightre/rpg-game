extends Control

@onready var hp_progress_bar: TextureProgressBar = $HBoxContainer/HpProgressBar
@onready var temperature_label: Label = $TemperatureLabel
@onready var cold_texture: NinePatchRect = $ColdTexture

func _on_player_info_hp_changed(new_hp: Variant) -> void:
	hp_progress_bar.value = new_hp

func _on_player_info_temperature_changed(new_temperature: Variant) -> void:
	temperature_label.text = "温度 %.f°" % new_temperature
	if new_temperature < 0.0:
		var alpha = inverse_lerp(0.0, -13.0, new_temperature)
		cold_texture.modulate.a = clamp(alpha, 0.0, 1.0)
	else:
		cold_texture.modulate.a = 0.0
