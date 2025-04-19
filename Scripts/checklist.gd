extends Control

@onready var checklist_text_container = $MarginContainer/ChecklistTextContainer
@onready var checklist = $"."
var mouse_position_inside = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_checklist_reference(checklist_text_container)
	
func _input(event):
	if event.is_action_released("select"):
		if checklist.visible == true and mouse_position_inside == false:
			checklist.visible = !checklist.visible
			Events.checklist_hidden.emit()
				

func _on_mouse_entered():
	mouse_position_inside = true
	print("mouse entered")

func _on_mouse_exited():
	mouse_position_inside = false
