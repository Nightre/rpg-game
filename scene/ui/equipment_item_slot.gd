extends ItemSlot

func can_hold_item(item:InventoryItem):
	return super.can_hold_item(item) and item.get_property("equippable", false)
