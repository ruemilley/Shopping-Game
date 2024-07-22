extends Node

#scene and node references

var last_main_position := Vector2(0,0)
var player_node: Node = null
var player_height := 0.0
var player_direction
@onready var inventory_slot_scene = preload("res://Scenes/inventory/inventory_slot.tscn")


#inventory management

var inventory := []

#inventory signals
signal inventory_updated



#arrays for items in scnees

var primary_aisle_items := [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"),"score": 300, "cost":1.50,  "iposition": Vector2(700,0)},
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "score": 150, "cost":1.50, "iposition": Vector2(800,0)}
]

#bakery aisle
var bakery_aisle_items := [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "score": 300, "cost":1.50, "iposition": Vector2(100,0)},
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "score": 150, "cost":1.50, "iposition": Vector2(200,0)}
]

var dairy_aisle_items := [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "score": 300, "cost":1.50, "iposition": Vector2(100,0)},
]

var produce_aisle_items := [
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "score": 150, "cost":1.50, "iposition": Vector2(200,0)}
]

var meat_aisle_items := [
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "score": 150, "cost":1.50, "iposition": Vector2(200,0)}
]

var frozen_aisle_items := [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "score": 300, "cost":1.50, "iposition": Vector2(100,0)},
]

var snack_aisle_items := [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "score": 300, "cost":1.50, "iposition": Vector2(100,0)},
]


func _ready():
	inventory.resize(30) #set inventory cap
	
func _process(_delta):
	if player_node != null:
		player_height = player_node.position.y

#inventory ui functions

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["iname"] == item["iname"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false

func remove_item(item_name, item_type):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["iname"] == item_name:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
				inventory_updated.emit()
			inventory_updated.emit()
			return true
	return false
	
func set_player_reference(player):
	player_node = player

#dropping item
func adjust_drop_position(position):
	var radius := 100
	var nearby_items = get_tree().get_nodes_in_group("items")
	for item in nearby_items:
		if item.position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), 0)
			position += random_offset
			break
	return position
	
func drop_item(_item_data, drop_position):
	var item_data = _item_data.duplicate()
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	item_data.iposition = item_instance.global_position
	get_tree().current_scene.add_child(item_instance)
	find_current_aisle().append(item_data)
	update_scene_items()
	

func update_scene_items():
	for i in get_tree().get_nodes_in_group("items"):
		i.get_node("InteractionArea").interact_value = i

func spawn_item(data):
	var item_scene = preload("res://Scenes/inventory/inventory_item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"], data["iname"], data["texture"], data["iposition"], data["score"], data["cost"])
	get_tree().current_scene.add_child(item_instance)
	item_instance.global_position = data["iposition"]
	update_scene_items()

func find_current_aisle():
	match get_tree().current_scene.name:
		"PrimaryAisle":
			return primary_aisle_items
		"BakeryAisle":
			return bakery_aisle_items
		"DairyAisle":
			return dairy_aisle_items
		"ProduceAisle":
			return produce_aisle_items
		"MeatAisle":
			return meat_aisle_items
		"FrozenAisle":
			return frozen_aisle_items
		"SnackAisle":
			return snack_aisle_items
		_:
			return null
			

