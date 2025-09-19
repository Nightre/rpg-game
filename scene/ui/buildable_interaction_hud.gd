extends Control
@onready var buildable_interaction_manager: BuildableInteractionManager = $BuildableInteractionManager

func open():
	pass

func close():
	if buildable_interaction_manager.buildable:
		buildable_interaction_manager.buildable.close_hud()
