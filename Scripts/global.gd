extends Node

#scene and node references

var last_main_position := Vector2(0,0)
var player_node: Node = null
var checklist_node: Node = null
var player_height := 0.0
var player_direction
@onready var inventory_slot_scene = preload("res://Scenes/inventory/inventory_slot.tscn")


#inventory management

var inventory := []

#inventory signals
signal inventory_updated

#array updating checklist status. starts empty because it will append the item

var checklist_items := [
]

#arrays for items in scnees

#BASE TEMPLATE:
#{"iname": "", "type": "", "texture": preload(""), "score": 0, "cost":1.50, "iposition": Vector2(0,0)},

var primary_aisle_items := [
]

#bakery/grain aisle
var bakery_aisle_items := [
	{"iname": "Color-O's Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/color-os cereal.png"), "score": 0, "cost":1.50, "iposition": Vector2(200,-435)},
	{"iname": "Farfalle", "type": "grain", "texture": preload("res://Assets/items/grains/farfalle.png"), "score": 0, "cost":1.50, "iposition": Vector2(2200,60)},
	{"iname": "Fettuccine", "type": "grain", "texture": preload("res://Assets/items/grains/fettuccine.png"), "score": 0, "cost":1.50, "iposition": Vector2(2100,60)},
	{"iname": "Health Nuts Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/health nuts cereal.png"), "score": 0, "cost":1.50, "iposition": Vector2(550,-435)},
	{"iname": "Spaghetti", "type": "grain", "texture": preload("res://Assets/items/grains/spaghetti.png"), "score": 0, "cost":1.50, "iposition": Vector2(1950,60)},
	{"iname": "White Bread", "type": "grain", "texture": preload("res://Assets/items/grains/white bread.png"), "score": 0, "cost":1.50, "iposition": Vector2(700,-130)},
	{"iname": "White Rice", "type": "grain", "texture": preload("res://Assets/items/grains/white rice.png"), "score": 0, "cost":1.50, "iposition": Vector2(1400,-130)},
	{"iname": "Whole Wheat Bread", "type": "grain", "texture": preload("res://Assets/items/grains/whole wheat bread.png"), "score": 0, "cost":1.50, "iposition": Vector2(920,-300)},
]

#dairy aisle
var dairy_aisle_items := [
]

#produce aisle
var produce_aisle_items := [
]

#meat
var meat_aisle_items := [
]

#frozen
var frozen_aisle_items := [
]

#snack aisle
var snack_aisle_items := [
]

#HUD management
var budget_value := 30.00
var cart_value := 00.00

#variables for checking out/endings/dialogue

var dialogue_active := false
var has_checked_out := false


func _ready():
	inventory.resize(30) #set inventory cap
	#connect signals
	Events.checklist_status_update.connect(_on_checklist_status_update)
	
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
			cart_value -= inventory[i]["cost"]
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
				inventory_updated.emit()
			inventory_updated.emit()
			return true
	return false
	
func set_player_reference(player):
	player_node = player
	
func set_checklist_reference(checklist):
	checklist_node = checklist

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

func update_checklist_items(checklist_item):
	for i in range(checklist_items.size()):
		if checklist_items[i]["text"] == checklist_item.text:
			checklist_item.crossout.visible = checklist_items[i]["visible"]

#signal receivers

#update the visibility of the checklist item crossout
func _on_checklist_status_update(visibility, text):
	if checklist_items.size() > 0:
		for i in range(checklist_items.size()):
			if checklist_items[i]["text"] == text:
				checklist_items[i]["visible"] = visibility
	var new_entry = {"text": text, "visible": visibility}
	if new_entry not in checklist_items:
		checklist_items.append(new_entry)
