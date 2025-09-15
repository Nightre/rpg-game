class_name PlayerInfo extends Node

signal hp_changed(new_hp)
signal temperature_changed(new_temperature)

@export var hp: float = 100.0: set = set_hp, get = get_hp
@export var temperature: float = 26.0: set = set_temperature, get = get_temperature

func set_hp(value: float) -> void:
	hp = value
	hp_changed.emit(hp)

func get_hp() -> float:
	return hp

func set_temperature(value: float) -> void:
	temperature = value
	temperature_changed.emit(temperature)

func get_temperature() -> float:
	return temperature
