class_name PlayerInfo extends Node

signal hp_changed(new_hp)
signal temperature_changed(new_temperature)
signal money_changed(new_money) # 金钱变化信号

@export var hp: float = 100.0: set = set_hp, get = get_hp
@export var temperature: float = 26.0: set = set_temperature, get = get_temperature
@export var money: int = 0: set = set_money, get = get_money  # 金钱，默认0

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

func set_money(value: int) -> void:
	money = max(0, value) # 防止出现负数
	money_changed.emit(money)

func get_money() -> int:
	return money

func _on_hurtbox_damaged(damage: Variant) -> void:
	hp = hp - damage
