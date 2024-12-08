extends Node2D

@onready var mom = $Mom
@onready var player_sprite = $Player/AnimatedSprite2d

# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://Dialogue/ending_dialogue.dialogue")
	if Global.ending_state == "empty" or Global.ending_state == "theft":
		DialogueManager.show_dialogue_balloon(resource, Global.ending_state)
	else:
		DialogueManager.show_dialogue_balloon(resource, "rating_parse")

