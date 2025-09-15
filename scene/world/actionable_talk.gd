extends ActionAble

@export var timeline = ""

func interact():
	super.interact()
	hide()
	if Dialogic.current_timeline != null:
		return
	Dialogic.start(timeline)
	await Dialogic.timeline_ended
	show()
