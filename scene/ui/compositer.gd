class_name Compositer extends Node

@export var inventory:Inventory
@export var container:VBoxContainer
@export var additional_composite:AdditionalCompositeArea
@export var player_info:PlayerInfo

const SPECIAL_ITEM = {
	"coin": {
		"image": preload("res://assets/image/item/item_coin.png"),
		"name": "金币"
	}
}

var is_dirty = false

func _ready() -> void:
	call_deferred("update_composite_list")

func get_item_quantity(prototype_id: String) -> int:
	match prototype_id:
		"coin":
			return player_info.money
		_:
			var items = inventory.get_items_with_prototype_id(prototype_id)
			var total = 0
			for item in items:
				total += item.get_stack_size() 
			return total

func remove_items_by_prototype(prototype_id: String, count: int) -> int:
	match prototype_id:
		"coin":
			player_info.money -= count
			return 0
		_:
			var items = inventory.get_items_with_prototype_id(prototype_id)
			var removed = 0
			
			for item in items:
				if removed >= count:
					break
				var stack_size = item.get_stack_size()
				var to_remove = min(count - removed, stack_size)
				
				if to_remove < stack_size:
					item.set_stack_size(stack_size - to_remove)
				else:
					inventory.remove_item(item)
				
				removed += to_remove
			
			return removed  # 返回实际移除的数量（防止库存不足）

func can_composite(material:Dictionary[String, int]):
	for item_id in material:
		if get_item_quantity(item_id) < material[item_id]:
			return false
	return true

func update_composite_list():
	remove_all()
		
	for title_text in additional_composite.additional:
		add_label(title_text)
		for composite in additional_composite.additional[title_text]:
			add_composite(composite)
	
	add_label("合成")
	for composite in Data.composites:
		add_composite(composite)

func remove_all():
	for child in container.get_children():
		child.queue_free()
		
func add_label(text):
	var tilte = Label.new()
	tilte.text = text
	container.add_child(tilte)

func add_composite(composite:CompositeData):
	if can_composite(composite.input):
		var button = preload("res://scene/ui/composite_button.tscn").instantiate()
		button.pressed.connect(func (): composite_button_pressed(composite))
		button.composite = composite
		button.inventory = inventory
		container.add_child(button)	

func _process(delta: float) -> void:
	if is_dirty:
		update_composite_list()
		is_dirty = false

func composite_button_pressed(composite: CompositeData):
	for input_item in composite.input:
		remove_items_by_prototype(input_item, composite.input[input_item])
		
	match composite.output:
		"coin":
			
			player_info.money += composite.output_num
		_:
			for i in composite.output_num:
				inventory.create_and_add_item(composite.output)


func _on_inventory_data_item_added(item: InventoryItem) -> void:
	is_dirty=true#update_composite_list()

func _on_inventory_data_item_removed(item: InventoryItem) -> void:
	is_dirty=true#update_composite_list()
