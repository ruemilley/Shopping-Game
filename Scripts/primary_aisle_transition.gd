extends Node2D
@onready var scene_transition = $SceneTransition

func _ready():
	scene_transition.fade_to_normal()
