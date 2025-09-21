class_name Buildable extends Node2D

signal pressed

@onready var place_area_2d: Area2D = $PlaceArea2D
@onready var collision_shape_2d_2: CollisionShape2D = $PlaceArea2D/CollisionShape2D2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var button: Button = $Button

@export var title = ""
@export var drops = ""
@export var can_open = false
@export var open_hud:PackedScene

var buildable_hud:BuildableHud
var in_build = false
var can_build = false

var disable_click = false

func set_in_build(is_in_build):
	print("set_in_build:", is_in_build)
	in_build = is_in_build
	#collision_shape_2d_2.disabled = !in_build
	if in_build:
		set_can_build(true)
		Global.hud.state = Global.hud.STATE.BUILDING
	else:
		sprite_2d.modulate = Color.WHITE
		Global.hud.state = Global.hud.STATE.IDLE
			
func _ready() -> void:
	button.disabled = not can_open
	Global.hud.state_changed.connect(on_state_changed)
	on_state_changed(Global.hud.state)
	
func on_state_changed(state):
	print("STATE_CHNAGE:", state)
	disable_click = not can_open or state != Global.hud.STATE.IDLE
	button.disabled = disable_click
		
func set_can_build(value: bool) -> void:
	can_build = value
	if can_build:
		sprite_2d.modulate = Color(0, 1, 0, 0.7)
	else:
		sprite_2d.modulate = Color(1, 0, 0, 0.7)

func _on_place_area_2d_body_entered(body: Node2D) -> void:
	if in_build:
		set_can_build(false)

func _on_place_area_2d_body_exited(body: Node2D) -> void:
	if in_build and len(place_area_2d.get_overlapping_bodies()) == 0:
		set_can_build(true)


func serialize():
	return {
		"position":position
	}
	
func deserialize(data):
	position = data["position"]

func create_hud():
	if can_open and open_hud:
		var instan = open_hud.instantiate()
		instan.buildable = self
		buildable_hud = instan
		init_hud(instan)
		return instan
		
func close_hud():
	buildable_hud.queue_free()
		
func init_hud(new_buildable_hud:BuildableHud):
	pass
	
func _on_button_pressed() -> void:
	if not in_build and not disable_click:
		pressed.emit()
		Global.buildable_interaction_manager.open_buildable(self)

func destory():
	Global.hud.close_all_hud()
	if drops:
		Global.drops.add_drop(drops, position)
	queue_free()
	
func can_use(item:InventoryItem):
	return false

func use_item(item:InventoryItem):
	item.get_inventory().remove_item(item)
