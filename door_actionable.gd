extends ActionAble

@onready var level = Global.level_manager
@export var path:String

func interact():
	super.interact()
	level.change_to_level(path)
