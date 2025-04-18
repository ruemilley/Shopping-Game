extends Node2D
@onready var mom = $Mom
@onready var player_sprite = $PlayerSpriteOnly
@onready var scene_transition = $SceneTransition

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var resource = load("res://Dialogue/intro_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "intro")
