extends Control

@onready var checklist_text_container = $MarginContainer/ChecklistTextContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_checklist_reference(checklist_text_container)
