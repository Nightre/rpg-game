class_name TechTreeManager extends Node

signal all_tree_node_added
signal node_unlocked(id: String)
signal node_locked(id: String)

@onready var name_label: Label = $"../Panel/NameLabel"
@onready var pre_label: Label = $"../Panel/PreLabel"
@onready var unlock_button: Button = $"../Panel/UnlockButton"
@onready var material_container: HBoxContainer = $"../Panel/MaterialContainer"
@export var compositer:Compositer

var tree_nodes:Dictionary[String, TechTreeNode] = {}
var unlocked_tree_nodes: Array[String] = []
var selected_tree:TechTreeNode = null

func add_tree_node(p:TechTreeNode):
	tree_nodes[p.id] = p

func _ready() -> void:
	for t in get_tree().get_nodes_in_group("tree_nodes"):
		add_tree_node(t)
	for t in get_tree().get_nodes_in_group("tree_nodes"):
		t.init_lines()
		t.update_visual_state()
		t.pressed.connect(func():select_tree(t))
	unlock_node("root")
	
func select_tree(tree:TechTreeNode):
	selected_tree = tree
	name_label.text = tree.data.title
	pre_label.text = "前置: "
	for pre in tree.data.prerequisites:
		pre_label.text += Data.tech_nodes[pre].title + " "
	unlock_button.visible = is_locked(tree.id)
	
	var materials = tree.data.materials
	unlock_button.disabled = not compositer.can_composite(materials)
	material_container.display(materials)
		
func is_prerequisites_unlocked(data:TechNodeData):
	for pre in data.prerequisites:
		if is_locked(pre):
			return false
	return true

func unlock_node(id: String) -> void:
	if not tree_nodes.has(id):
		return
	if id not in unlocked_tree_nodes:
		unlocked_tree_nodes.append(id)
		node_unlocked.emit(id)

func lock_node(id: String) -> void:
	if not tree_nodes.has(id):
		return
	if id in unlocked_tree_nodes:
		unlocked_tree_nodes.erase(id)
		node_locked.emit(id)

func unlock_all() -> void:
	for id in tree_nodes.keys():
		unlock_node(id)

func lock_all() -> void:
	for id in tree_nodes.keys():
		lock_node(id)

func is_locked(id: String) -> bool:
	if not tree_nodes.has(id):
		return true
	return id not in unlocked_tree_nodes

func _on_unlock_button_pressed() -> void:
	if selected_tree and compositer.can_composite(selected_tree.data.materials):
		unlock_node(selected_tree.id)
		select_tree(selected_tree)
		var materials = selected_tree.data.materials
		for input_item in materials:
			compositer.remove_items_by_prototype(input_item, materials[input_item])
		
		
