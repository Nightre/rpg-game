class_name StateMachine
extends Node

@export var initial_state: State
var current_state: State
var previous_state: State
var owner_node: Node

func _ready() -> void:
	if initial_state:
		change_state(initial_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		current_state.set_process(false)
		current_state.set_physics_process(false)
		previous_state = current_state

	current_state = new_state
	if current_state:
		current_state.state_machine = self
		current_state.owner_node = owner_node
		current_state.enter()
		current_state.set_process(true)
		current_state.set_physics_process(true)
