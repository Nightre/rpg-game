extends TabBar

@onready var equipment: Panel = $"../Equipment"
@onready var composite: Panel = $"../Composite"

func _ready() -> void:
	current_tab = 0
	
func _on_tab_changed(tab: int) -> void:
	composite.visible = tab == 1
	equipment.visible = tab == 0

func init_tabbar():
	current_tab = 0
	_on_tab_changed(current_tab)
