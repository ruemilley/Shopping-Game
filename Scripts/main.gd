extends Node

@onready var first_scene = "res://Scenes/primary_aisle.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file(first_scene)


