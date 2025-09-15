class_name CompositeButton extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var prototree = inventory.get_prototree()
@onready var material_container: HBoxContainer = $MaterialContainer

@export var inventory:Inventory
@export var composite:CompositeData

func _ready() -> void:
	var output_item = inventory.create_item(composite.output)
	texture_rect.texture = output_item.get_texture()
	label.text = output_item.get_title()
	
	for material_item_id in composite.input:
		var item = inventory.create_item(material_item_id)
		
		var texture = TextureRect.new()
		texture.texture = item.get_texture()
		
		var num_label = Label.new()
		num_label.text = '*'+str(composite.input[material_item_id])
		
		material_container.add_child(texture)
		material_container.add_child(num_label)
