extends Control

@onready var checklist_text_container = $MarginContainer/ChecklistTextContainer
@onready var checklist = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_checklist_reference(checklist_text_container)
	
func _input(event):
	if event.is_action_released("select"):
		if checklist.visible == true and Global.mouse_position_inside == false:
			checklist.visible = !checklist.visible
			Events.checklist_hidden.emit()



func _on_mouse_entered():
	Global.mouse_position_inside = true
	
func _on_mouse_exited():
	Global.mouse_position_inside = false
