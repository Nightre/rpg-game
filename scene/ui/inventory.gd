extends Control
@onready var item_info_panel: Panel = $Panel/HBoxContainer/ItemInfoPanel
@onready var tab_bar: TabBar = $TabBar

func open():
	item_info_panel.init_info()
	tab_bar.init_tabbar()
