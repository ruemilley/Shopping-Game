@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_score: int
@export var item_cost: float
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
		"score" : item_score,
		"cost" : item_cost,
		"scene_path" : scene_path,
		"iposition" : item_position,
	}
	if Global.player_node:
		Global.add_item(item)
		var _current_scene_items = null
		match get_tree().current_scene.name:
			"Primary Aisle":
				update_item_arrays(Global.primary_aisle_items, item)
			"Aisle":
				update_item_arrays(Global.aisle_items, item)
			_:
				pass
		self.queue_free()
		
func update_item_arrays(current_scene_items, item):
	for i in range(current_scene_items.size()):
		if current_scene_items[i]["iname"] == item["iname"] and current_scene_items[i]["iposition"] == item["iposition"]:
			current_scene_items.pop_at(i)
			break
		else:
			pass

func set_item_data(data):
	item_name = data["iname"]
	item_type = data["type"]
	item_texture = data["texture"]
	item_score = data["score"]
	item_cost = data["cost"]
	item_position = data["iposition"]

func initiate_items(type, iname, texture, iposition, score, cost):
	item_type = type
	item_name = iname
	item_texture = texture
	item_position = iposition
	item_score = score
	item_cost = cost