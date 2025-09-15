extends Control
@onready var item_info_panel: Panel = $Panel/HBoxContainer/ItemInfoPanel

func open():
	item_info_panel.init_info()
