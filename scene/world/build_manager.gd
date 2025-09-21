class_name BuildManager
extends Node
@onready var level_manager: LevelManager = $"../LevelManager"

signal building_selected(item: InventoryItem)
signal building_canceled()
signal building_built(item: InventoryItem, instance: Node2D)

var selected_building: Buildable = null
var building_item:InventoryItem = null

func get_build_parent():
	return level_manager.level

# 选中建造物
func select_building(item: InventoryItem) -> void:
	building_item = item
	Global.hud.state = Global.hud.STATE.BUILDING 

	var item_build_scene =  Data.item_build_scene
	var id = building_item.get_property("id")
	var scene:PackedScene = item_build_scene[id]
	
	selected_building = scene.instantiate()
	
	building_selected.emit(building_item)
	selected_building.call_deferred("set_in_build", true)
	get_build_parent().add_child(selected_building)

func cancel_selection() -> void:
	selected_building = null
	building_canceled.emit()

func _process(delta: float) -> void:
	if selected_building:
		selected_building.position = get_build_parent().get_local_mouse_position()

func build() -> void:
	if selected_building and selected_building.can_build:
		building_item.get_inventory().remove_item(building_item)
		selected_building.set_in_build(false)
		cancel_selection()

func _input(event: InputEvent) -> void:
	if selected_building:
		if Input.is_action_just_released("build"):
			build()
		elif Input.is_action_just_pressed("cancel"):
			selected_building.queue_free()
			cancel_selection()
