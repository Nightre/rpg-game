extends Buildable

var inventory_data:Dictionary

func init_hud(new_buildable_hud:BuildableHud):
	await new_buildable_hud.ready
	var inventory = new_buildable_hud.inventory as Inventory
	inventory.clear()
	
	inventory.item_added.connect(on_inventory_changed)
	inventory.item_moved.connect(on_inventory_changed)
	inventory.deserialize(inventory_data)

func on_inventory_changed(item: InventoryItem):
	var inventory = buildable_hud.inventory as Inventory
	inventory_data = inventory.serialize()

func serialize():
	return {
		"position": position,
		"inventory_data": inventory_data
	}
	
func deserialize(data):
	super(data)
	inventory_data = data["inventory_data"]
