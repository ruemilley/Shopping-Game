@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_position: Vector2

var scene_path: String = "res://Scenes/inventory/inventory_item.tscn"

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
		"iname" : item_name,
		"texture" : item_texture,
		"scene_path" : scene_path,
		"iposition" : item_position,
	}
	if Global.player_node:
		Global.add_item(item)
		match get_tree().current_scene.name:
			"Primary Aisle":
				for i in range(Global.primary_aisle_items.size()):
					if Global.primary_aisle_items[i]["iname"] == item["iname"] and Global.primary_aisle_items[i]["iposition"] == item["iposition"]:
						Global.primary_aisle_items.pop_at(i)
						break
					else:
						pass
			"Aisle":
				print("Aisle")
			_:
				print("no inventory to update")
		self.queue_free()

func set_item_data(data):
	item_name = data["iname"]
	item_type = data["type"]
	item_texture = data["texture"]
	item_position = data["iposition"]

func initiate_items(type, iname, texture, iposition):
	item_type = type
	item_name = iname
	item_texture = texture
	item_position = iposition
