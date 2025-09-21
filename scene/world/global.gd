extends Node

var current_game:Game
var player:Player
var level_manager:LevelManager
var hud:HUD
var buildable_interaction_manager:BuildableInteractionManager
var drops:DropsManager

func add_quset(id):
	current_game.quest_manager.add_quest(id)
	
func complete_quest(id):
	current_game.quest_manager.complete_quest(id)

func is_quest_completed(id):
	return current_game.quest_manager.is_quest_completed(id)

func is_quest_accepted(id):
	return current_game.quest_manager.is_quest_accepted(id)
