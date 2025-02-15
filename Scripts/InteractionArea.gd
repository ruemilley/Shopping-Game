class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"
@export var dialogue_resource ="none"
@export var auto_interaction = false

func _ready():
	if dialogue_resource != "none":
		load(dialogue_resource)
