extends Node

@onready var first_scene = "res://Scenes/primary_aisle.tscn"


func _on_start_button_pressed():
	get_tree().change_scene_to_file(first_scene)
