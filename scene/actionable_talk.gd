extends ActionAble

@export var timeline = ""

func interact():
	super.interact()
	if Dialogic.current_timeline != null:
		return
	Dialogic.start(timeline)
