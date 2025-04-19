extends Node2D
@onready var player_sprite = $PlayerSprite
@onready var scene_transition = $SceneTransition

func _ready():
	player_sprite.play("run")
	var resource = load("res://Dialogue/ending_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "theft")
