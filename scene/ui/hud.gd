class_name HUD extends Control

@onready var inventory: Control = %Inventory
@onready var buildable_interaction: Control = %BuildableInteraction

enum HUD_TYPE {
	INVENTORY,
	BUILDABLE,
}

var current_huds: Array = []   # 支持多个 HUD

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if len(current_huds) > 0:
			close_all_hud()
		else:
			open_hud(HUD_TYPE.INVENTORY)

# 打开 HUD
func open_hud(hud_type: int) -> void:
	if hud_type not in current_huds:
		current_huds.append(hud_type)
	print("open_hud", hud_type)

	match hud_type:
		HUD_TYPE.INVENTORY:
			set_open_inventory(true)
		HUD_TYPE.BUILDABLE:
			set_open_buildable(true)

# 关闭 HUD
func close_hud(hud_type: int) -> void:
	print("open_hud", hud_type)
	
	if not hud_type in current_huds:
		return
		
	
	current_huds.erase(hud_type)

	match hud_type:
		HUD_TYPE.INVENTORY:
			set_open_inventory(false)
		HUD_TYPE.BUILDABLE:
			set_open_buildable(false)

func close_all_hud():
	for h in HUD_TYPE.values():
		close_hud(h)

# UI 控制
func set_open_buildable(new_open_buildable: bool):
	buildable_interaction.visible = new_open_buildable
	if new_open_buildable:
		buildable_interaction.open()
	else:
		buildable_interaction.close()

func set_open_inventory(new_open_inventory: bool):
	inventory.visible = new_open_inventory
	if new_open_inventory:
		inventory.open()

func _on_build_manager_building_selected(item: InventoryItem) -> void:
	close_all_hud()
