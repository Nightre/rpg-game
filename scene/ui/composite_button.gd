class_name CompositeButton extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var prototree = inventory.get_prototree()
@onready var material_container: HBoxContainer = $MaterialContainer

@export var inventory:Inventory
@export var composite:CompositeData

func _ready() -> void:
	match composite.output:
		"coin":
			texture_rect.texture = Compositer.SPECIAL_ITEM[composite.output]["image"]
			label.text =  Compositer.SPECIAL_ITEM[composite.output]["name"]
		_:
			var output_item = inventory.create_item(composite.output)
			texture_rect.texture = output_item.get_texture()
			label.text = output_item.get_title()
			
	if composite.output_num > 1:
		label.text += '*' +str(composite.output_num)
		
	material_container.display(composite.input)
	#for material_item_id in composite.input:
		#var texture = TextureRect.new()
		#match material_item_id:
			#"coin":
				#texture.texture = Compositer.SPECIAL_ITEM[material_item_id]["image"]
			#_:
				#var item = inventory.create_item(material_item_id)
				#texture.texture = item.get_texture()
		#
		#var num_label = Label.new()
		#num_label.text = '*'+str(composite.input[material_item_id])
		#
		#material_container.add_child(texture)
		#material_container.add_child(num_label)
