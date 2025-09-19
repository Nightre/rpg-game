class_name State extends Node

var owner_node: CharacterBody2D
var state_machine: StateMachine

# 进入此状态时调用
func enter() -> void:
	pass

# 退出此状态时调用
func exit() -> void:
	pass

# _process 每帧调用
func process(delta: float) -> void:
	pass

# _physics_process 固定帧率调用，用于物理和移动
func physics_process(delta: float) -> void:
	pass
