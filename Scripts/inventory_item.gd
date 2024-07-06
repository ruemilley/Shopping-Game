@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture

var scene_path: String = "res://Scenes/inventory_item.tscn"

@onready var item_sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		item_sprite.texture = item_texture
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		item_sprite.texture = item_texture
		
func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"texture" : item_texture,
		"scene_path" : scene_path,
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()

func set_item_data(data):
	item_name = data["name"]
	item_type = data["type"]
	item_texture = data["texture"]

