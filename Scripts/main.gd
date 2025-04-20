extends Node

@onready var first_scene = "res://Scenes/opening.tscn"

func _ready():
	SoundManager.play_general_theme_music()

func _on_start_button_pressed():
	get_tree().change_scene_to_file(first_scene)
