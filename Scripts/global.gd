extends Node


var last_main_position = Vector2(0,0)

#scene and node references

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")
@onready var scene_items = get_tree().get_nodes_in_group("items")

#inventory management

var inventory = []

#inventory signals
signal inventory_updated

func _ready():
	inventory.resize(30) #set inventory cap
	update_scene_items()
	

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		return false

func remove_item(item_type, item_name):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
		return false
	
func set_player_reference(player):
	player_node = player

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
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.position = drop_position
	print(get_tree().get_nodes_in_group("items"))
	update_scene_items()

func update_scene_items():
	if scene_items.size() > 0:
		for i in scene_items:
			print(i)
			i.get_node("InteractionArea").interact_value = i
	
