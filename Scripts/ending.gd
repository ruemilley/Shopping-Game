extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://Dialogue/ending_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, Global.ending_state)

