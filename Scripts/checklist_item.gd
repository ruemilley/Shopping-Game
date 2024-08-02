extends RichTextLabel

@onready var crossout = $Crossout

func _gui_input(event):
	if event.is_action_pressed("select"):
		crossout.visible = !crossout.visible
