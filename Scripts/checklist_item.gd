extends RichTextLabel

@onready var crossout = $Crossout
@onready var checklist_item = $"."

func _ready():
	Global.update_checklist_items(self)

func _gui_input(event):
	if event.is_action_pressed("select"):
		Global.mouse_position_inside = true
		crossout.visible = !crossout.visible
		Events.checklist_status_update.emit(crossout.visible, text)
		SoundManager.play_checklist_sound()



func _on_crossout_gui_input(event):
	if event.is_action_pressed("select"):
		Global.mouse_position_inside = true
		crossout.visible = !crossout.visible
		Events.checklist_status_update.emit(crossout.visible, text)
		SoundManager.play_checklist_sound()
