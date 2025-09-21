extends HBoxContainer

@export var inventory:Inventory

func display(materials:Dictionary[String, int]) -> void:
	for child in get_children():
		child.queue_free()
	for material_item_id in materials:
		var texture = TextureRect.new()
		match material_item_id:
			"coin":
				texture.texture = Compositer.SPECIAL_ITEM[material_item_id]["image"]
			_:
				var item = inventory.create_item(material_item_id)
				texture.texture = item.get_texture()
		
		var num_label = Label.new()
		num_label.text = '*'+str(materials[material_item_id])
		
		add_child(texture)
		add_child(num_label)
