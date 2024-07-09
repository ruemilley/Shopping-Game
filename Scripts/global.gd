extends Node

#scene and node references

var last_main_position = Vector2(0,0)
var player_node: Node = null
var player_height = 0.0
var player_direction
@onready var inventory_slot_scene = preload("res://Scenes/inventory/inventory_slot.tscn")


#inventory management

var inventory = []

#inventory signals
signal inventory_updated
var spawnable_items = [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png")},
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png")}
]


#arrays for items in scnees

var primary_aisle_items = [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "iposition": Vector2(700,0)},
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "iposition": Vector2(800,0)}
]

#placeholder for aisle
var aisle_items = [
	{"type": "Fruit", "iname": "Orange", "texture": preload("res://Assets/placeholder/orange-1218158_960_720.png"), "iposition": Vector2(100,0)},
	{"type": "Fruit", "iname": "Apple", "texture": preload("res://Assets/placeholder/pngtree-fresh-apple-fruit-red-png-image_10203073.png"), "iposition": Vector2(200,0)}
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
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("items")
	for item in nearby_items:
		if item.position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), 0)
			position += random_offset
			break
	return position
	
func drop_item(item_data, drop_position):
	print(aisle_items)
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	item_data.iposition = item_instance.global_position
	get_tree().current_scene.add_child(item_instance)
	match get_tree().current_scene.name:
		"Primary Aisle":
			primary_aisle_items.append(item_data)
			print(aisle_items)
		"Aisle":
			aisle_items.append(item_data)
		_:
			print("no inventory to update")
	update_scene_items()
	

func update_scene_items():
	for i in get_tree().get_nodes_in_group("items"):
		i.get_node("InteractionArea").interact_value = i

func spawn_item(data):
	var item_scene = preload("res://Scenes/inventory/inventory_item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"], data["iname"], data["texture"], data["iposition"])
	get_tree().current_scene.add_child(item_instance)
	item_instance.global_position = data["iposition"]
	update_scene_items()
