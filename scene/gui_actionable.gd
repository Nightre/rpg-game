extends ActionAble
@export var gui:InventoryGUI

func interact():
	var hud = Global.current_game.hud
	hud.set_open_inventory(true, gui)
	
