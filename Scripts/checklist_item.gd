extends RichTextLabel

@onready var crossout = $Crossout

func _ready():
	Global.update_checklist_items(self)

func _gui_input(event):
	if event.is_action_pressed("select"):
		crossout.visible = !crossout.visible
		Events.checklist_status_update.emit(crossout.visible, text)
