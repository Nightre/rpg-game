class_name BuildManager
extends Node

signal building_selected(item: InventoryItem)
signal building_canceled()
signal building_built(item: InventoryItem, instance: Node2D)

@export var build_parent: Node2D
var selected_building: Buildable = null
var building_item:InventoryItem = null
# 选中建造物
func select_building(item: InventoryItem) -> void:
	building_item = item
	var scene = Data.item_build_scene[building_item.get_property("id")]
	selected_building = scene.instantiate()
	building_selected.emit(building_item)
	selected_building.call_deferred("set_in_build", true)
	build_parent.add_child(selected_building)

func cancel_selection() -> void:
	selected_building = null
	building_canceled.emit()

func _process(delta: float) -> void:
	if selected_building:
		selected_building.position = build_parent.get_local_mouse_position()

func build() -> void:
	if selected_building and selected_building.can_build:
		building_item.get_inventory().remove_item(building_item)
		selected_building.set_in_build(false)
		cancel_selection()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("build"):
		build()
	elif Input.is_action_just_pressed("cancel"):
		selected_building.queue_free()
		cancel_selection()
