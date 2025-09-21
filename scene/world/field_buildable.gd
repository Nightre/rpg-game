class_name FieldBuildable extends Buildable

@onready var crop: Sprite2D = $Crop
@onready var field: Sprite2D = $Sprite2D

var seed_time = 0
var maturity_time = 16 # 秒
var seed_type:InventoryItem = null

var max_moisture = 8
var moisture_level = 0

# 🌾 帧数常数
const CROP_FRAMES = 4 # 作物总帧数 (0-3)
const FIELD_FRAMES = 3 # 田地总帧数 (0-2)

func can_use(item:InventoryItem):
	return item.get_property("id") in ["seed", "fertilizer", "kettle"]

func seeding(item:InventoryItem):
	seed_time = 0
	seed_type = item
	crop.show()

func harvest():
	if seed_time >= maturity_time:
		for i in 3:
			Global.drops.add_drop("leaf", position)
	
	remove_crop()
		
func remove_crop():
	if seed_type:
		seed_time = 0
		seed_type = null
		crop.hide()
		
func use_item(item:InventoryItem):
	var id = item.get_property("id")
	match id:
		"seed":
			super(item)
			seeding(item)
		"fertilizer":
			super(item)
			seed_time += 16
		"kettle":
			moisture_level = 0

func _process(delta: float) -> void:
	if seed_type:
		seed_time += delta
		if seed_time > maturity_time:
			seed_time = maturity_time
			
		var current_frame = int((seed_time / maturity_time) * CROP_FRAMES)
		current_frame = clamp(current_frame, 0, CROP_FRAMES - 1)
		crop.frame = current_frame

	moisture_level += delta
	if moisture_level > max_moisture:
		moisture_level = max_moisture
		remove_crop()

	var current_fild = int((moisture_level / max_moisture) * FIELD_FRAMES)
	current_fild = clamp(current_fild, 0, FIELD_FRAMES - 1)
	field.frame = current_fild

func watering(water):
	moisture_level -= water
	moisture_level = clamp(moisture_level, 0, INF)

func _on_actionable_interacted() -> void:
	harvest()
