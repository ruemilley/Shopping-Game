extends Node

#scene and node references

var last_main_position := Vector2(0,0)
var player_node: Node = null
var checklist_node: Node = null
var player_height := 0.0
var player_direction
var player_pos
var is_running := false
@onready var inventory_slot_scene = preload("res://Scenes/inventory/inventory_slot.tscn")


#inventory signals
signal inventory_updated

#inventory management

var inventory := []

#array updating checklist status. starts empty because it will append the item

var checklist_items := [
]

#arrays for items in scnees

#BASE TEMPLATE:
#{"iname": "", "type": "", "texture": preload(""), "paid": false, "cost":1.50, "iposition": Vector2(0,0)},

var primary_aisle_items := []

var bakery_aisle_items := [
	{"iname": "Color-O's Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/color-os cereal.png"), "paid": false, "cost":6.50, "iposition": Vector2(200,-435), "desc": "This is The Best cereal because it has colors.",},
	{"iname": "Farfalle", "type": "grain", "texture": preload("res://Assets/items/grains/farfalle.png"), "paid": false, "cost":2.79, "iposition": Vector2(2200,60), "desc": "They're shaped like little bowties!",},
	{"iname": "Fettuccine", "type": "grain", "texture": preload("res://Assets/items/grains/fettuccine.png"), "paid": false, "cost":1.25, "iposition": Vector2(2100,60), "desc": "This just looks like wide spaghetti. But it's on sale.",},
	{"iname": "Health Nuts Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/health nuts cereal.png"), "paid": false, "cost":5.50, "iposition": Vector2(550,-435), "desc": "This is The Worst cereal because it has nuts. Mom likes it though.",},
	{"iname": "Spaghetti", "type": "grain", "texture": preload("res://Assets/items/grains/spaghetti.png"), "paid": false, "cost":2.79, "iposition": Vector2(1950,60), "desc": "A normal pasta.",},
	{"iname": "White Bread", "type": "grain", "texture": preload("res://Assets/items/grains/white bread.png"), "paid": false, "cost":2.29, "iposition": Vector2(700,-130), "desc": "Unnaturally soft and pillowy, but in a good way.",},
	{"iname": "White Rice", "type": "grain", "texture": preload("res://Assets/items/grains/white rice.png"), "paid": false, "cost":2.50, "iposition": Vector2(1400,-130), "desc": "This is good if you put a lot of other stuff on top of it.",},
	{"iname": "Whole Wheat Bread", "type": "grain", "texture": preload("res://Assets/items/grains/whole wheat bread.png"), "paid": false, "cost":4.50, "iposition": Vector2(920,-300), "desc": "The slices are really thick and they have the little nuts and oats on top.",},
]

#dairy aisle
var dairy_aisle_items := [
	{"iname": "Eggs", "type": "dairy", "texture": preload("res://Assets/items/dairy/eggs.png"), "paid": false, "cost":3.00, "iposition": Vector2(2250,-120), "desc": "You checked to make sure they're not cracked.",},
	{"iname": "Fancy Eggs", "type": "dairy", "texture": preload("res://Assets/items/dairy/fancy eggs.png"), "paid": false, "cost":5.00, "iposition": Vector2(2300,-620), "desc": "These ones are brown which I think means they're better somehow?",},
	{"iname": "Oat Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/oat milk.png"), "paid": false, "cost":4.00, "iposition": Vector2(400,-300), "desc": "Mom puts oat milk in her coffee sometimes. But only at the coffee shop.",},
	{"iname": "Organic Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/organic milk.png"), "paid": false, "cost":4.00, "iposition": Vector2(0,50), "desc": "Whoa, the cow looks happier on this one. That probably means something.",},
	{"iname": "Whole Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/whole milk.png"), "paid": false, "cost":2.00, "iposition": Vector2(0,-290), "desc": "You don't really like drinking milk but it's good for cereal and stuff.",},
]

#produce aisle
var produce_aisle_items := [
	{"iname": "Apple", "type": "produce", "texture": preload("res://Assets/items/produce/apple.png"), "paid": false, "cost":1.00, "iposition": Vector2(1550,-150), "desc": "You're always a little worried there will be a worm inside. There hasn't been before, but like... maybe...",},
	{"iname": "Orange", "type": "produce", "texture": preload("res://Assets/items/produce/orange.png"), "paid": false, "cost":1.49, "iposition": Vector2(1200,-180), "desc": "Surprisingly a lot of work to eat.",},
	{"iname": "Red Onion", "type": "produce", "texture": preload("res://Assets/items/produce/red onion.png"), "paid": false, "cost":0.75, "iposition": Vector2(500,0), "desc": "This one makes your eyes water like crazy when Mom cuts it up.",},
	{"iname": "Spinach", "type": "produce", "texture": preload("res://Assets/items/produce/spinach.png"), "paid": false, "cost":4.00, "iposition": Vector2(2600,-150), "desc": "It's spinch.",},
	{"iname": "White Onion", "type": "produce", "texture": preload("res://Assets/items/produce/white onion.png"), "paid": false, "cost":0.89, "iposition": Vector2(700,0), "desc": "Mom just said onion... So it's probably this one, right?",},
]

#meat
var meat_aisle_items := [
	{"iname": "Chicken Breasts", "type": "meat", "texture": preload("res://Assets/items/meat/chicken breasts.png"), "paid": false, "cost":11.99, "iposition": Vector2(1500,-280), "desc": "Ew, why does it have the little white veins?",},
	{"iname": "Ground Beef", "type": "meat", "texture": preload("res://Assets/items/meat/ground beef.png"), "paid": false, "cost":13.00, "iposition": Vector2(300,-280), "desc": "It looks kinda gross like this but it's really good in spaghetti and stuff.",},
	{"iname": "Salmon Filet", "type": "meat", "texture": preload("res://Assets/items/meat/salmon filet.png"), "paid": false, "cost":14.99, "iposition": Vector2(2150,-280), "desc": "Delicious fishes.",},
	{"iname": "Tofu", "type": "meat", "texture": preload("res://Assets/items/meat/tofu.png"), "paid": false, "cost":3.49, "iposition": Vector2(2700,-580), "desc": "Why was this in the meat aisle?",},
]

#frozen
var frozen_aisle_items := [
	{"iname": "Frozen Chicken Nuggets", "type": "frozen", "texture": preload("res://Assets/items/frozen/frozen chicken nuggets.png"), "paid": false, "cost":11.50, "iposition": Vector2(1400,70), "desc": "Way better than plain old chicken.",},
	{"iname": "Frozen Chicken", "type": "frozen", "texture": preload("res://Assets/items/frozen/frozen chicken.png"), "paid": false, "cost":10.00, "iposition": Vector2(1100,70), "desc": "An economical choice.",},
	{"iname": "Vanilla Ice Cream", "type": "frozen", "texture": preload("res://Assets/items/frozen/vanilla ice cream.png"), "paid": false, "cost":5.00, "iposition": Vector2(2000,-140), "desc": "Try saying vanilla bean ice cream five times fast. ...Not that it's hard or anything, it's just fun that it rhymes.",},
]

#snack aisle
var snack_aisle_items := [
	{"iname": "Boring Chips", "type": "snack", "texture": preload("res://Assets/items/snack/boring chips.png"), "paid": false, "cost":4.00, "iposition": Vector2(750,-280), "desc": "What's the point of a chip if it's not exploding with flavor?",},
	{"iname": "Chipz", "type": "snack", "texture": preload("res://Assets/items/snack/chipz.png"), "paid": false, "cost":3.00, "iposition": Vector2(380,50), "desc": "Chipz is the best and coolest chip, because there's a z at the end. That's what all the ads say at least.",},
	{"iname": "Choco Bar", "type": "snack", "texture": preload("res://Assets/items/snack/choco bar.png"), "paid": false, "cost":2.00, "iposition": Vector2(1900,-550), "desc": "Mom always says cats aren't supposed to eat chocolate... But cats also aren't supposed to wear clothes and go to the grocery store.",},
	{"iname": "Soda", "type": "snack", "texture": preload("res://Assets/items/snack/soda.png"), "paid": false, "cost":1.50, "iposition": Vector2(2250,70), "desc": "Delicious carbonation.",},
]




#HUD management
var budget_value := 30.00
var cart_value := 00.00

#variables for checking out/endings/dialogue

var dialogue_active := false
var has_checked_out := false
var ending_state := "empty"
var ending_checklist := {
	"eggs" : false,
	"milk" : false,
	"cereal" : false,
	"protein" : false,
	"bread" : false,
	"fruit" : false,
	"onion" : false,
	"grain" : false,
	"treat" : false,
}
var ending_checklist_count := {
	"eggs" : 0,
	"milk" : 0,
	"cereal" : 0,
	"protein" : 0,
	"bread" : 0,
	"fruit" : 0,
	"onion" : 0,
	"grain" : 0,
	"treat" : 0,
}
var nuggy := false
var tofu := false
var spinach := false
var white := false
var red := false


func _ready():
	inventory.resize(20) #set inventory cap
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
			get_tree().call_group("HUD", "update_money_counter_text", Global.cart_value)
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
	item_instance.initiate_items(data["type"], data["iname"], data["texture"], data["iposition"], data["paid"], data["cost"], data["desc"])
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

func cart_checkout():
	for i in range(inventory.size()):
		if inventory[i] != null:
			inventory[i]["paid"] = true
	get_tree().call_group("HUD", "update_money_counter_text", budget_value)
	get_tree().call_group("HUD", "update_money_counter_text", cart_value)

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

#initialize ending

func init_ending():
	#check if inventory is empty
	if inventory.all(return_inventory_val) == true:
		ending_state = "empty"
		get_tree().change_scene_to_file("res://Scenes/ending.tscn")
		return
	for i in range(inventory.size()):
		if inventory[i] != null:
			#check if you're stealing from the store
			if inventory[i]["paid"] == false:
				ending_state = "theft"
				break
			#check if you have eggs
			if inventory[i]["iname"] == "Eggs" or inventory[i]["iname"] == "Fancy Eggs":
				ending_checklist["eggs"] = true
				ending_checklist_count["eggs"] += 1
			#check if you have milk
			elif inventory[i]["iname"] == "Oat Milk" or inventory[i]["iname"] == "Organic Milk" or inventory[i]["iname"] == "Whole Milk":
				ending_checklist["milk"] = true
				ending_checklist_count["milk"] += 1
			#check cereal
			elif inventory[i]["iname"] == "Color-O's Cereal" or inventory[i]["iname"] == "Health Nuts Cereal":
				ending_checklist["cereal"] = true
				ending_checklist_count["cereal"] += 1
			#check chicken/protein
			elif inventory[i]["iname"] == "Frozen Chicken Nuggets" or inventory[i]["iname"] == "Frozen Chicken" or inventory[i]["iname"] == "Chicken Breasts" or inventory[i]["iname"] == "Ground Beef" or inventory[i]["iname"] == "Salmon Filet" or inventory[i]["iname"] == "Tofu":
				ending_checklist["protein"] = true
				ending_checklist_count["protein"] += 1
				if inventory[i]["iname"] == "Frozen Chicken Nuggets":
					nuggy = true
				if inventory[i]["iname"] == "Tofu":
					tofu = true
			#bread
			elif inventory[i]["iname"] == "Whole Wheat Bread" or inventory[i]["iname"] == "White Bread":
				ending_checklist["bread"] = true
				ending_checklist_count["bread"] += 1
			#fruit
			elif inventory[i]["iname"] == "Apple" or inventory[i]["iname"] == "Orange":
				ending_checklist["fruit"] = true
				ending_checklist_count["fruit"] += 1
			#vegetable
			elif inventory[i]["iname"] == "Red Onion" or inventory[i]["iname"] == "White Onion":
				ending_checklist["onion"] = true
				ending_checklist_count["onion"] += 1
				if inventory[i]["iname"] == "Red Onion":
					red = true
				else: 
					white = true
			#grain
			elif inventory[i]["iname"] == "Farfalle" or inventory[i]["iname"] == "Fettuccine" or inventory[i]["iname"] == "Spaghetti" or inventory[i]["iname"] == "White Rice":
				ending_checklist["grain"] = true
				ending_checklist_count["grain"] += 1
			#treat
			elif inventory[i]["iname"] == "Vanilla Ice Cream" or inventory[i]["iname"] == "Boring Chips" or inventory[i]["iname"] == "Chipz" or inventory[i]["iname"] == "Choco Bar" or inventory[i]["iname"] == "Soda":
				ending_checklist["treat"] = true
				ending_checklist_count["treat"] += 1
			elif inventory[i]["iname"] == "Spinach":
				spinach = true
	var ending_balance := 0
	var ending_balance_cap : float = ending_checklist.size()
	for i in ending_checklist.values():
		if i == true:
			ending_balance += 1
	if ending_balance <= ending_balance_cap / 2:
		ending_state = "bad"
	if ending_balance < ending_balance_cap and ending_balance > ending_balance_cap / 2 :
		ending_state = "okay"
	if ending_balance >= ending_balance_cap:
		ending_state = "good"
	get_tree().change_scene_to_file("res://Scenes/ending.tscn")

func return_inventory_val(i):
	return i == null

func reset_game_state():
	#inventory management
	inventory = []
#array updating checklist status. starts empty because it will append the item
	checklist_items = [
	]
#arrays for items in scnees
	primary_aisle_items = [
	]

	bakery_aisle_items = [
		{"iname": "Color-O's Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/color-os cereal.png"), "paid": false, "cost":6.50, "iposition": Vector2(200,-435), "desc": "This is The Best cereal because it has colors.",},
		{"iname": "Farfalle", "type": "grain", "texture": preload("res://Assets/items/grains/farfalle.png"), "paid": false, "cost":2.79, "iposition": Vector2(2200,60), "desc": "They're shaped like little bowties!",},
		{"iname": "Fettuccine", "type": "grain", "texture": preload("res://Assets/items/grains/fettuccine.png"), "paid": false, "cost":1.25, "iposition": Vector2(2100,60), "desc": "This just looks like wide spaghetti. But it's on sale.",},
		{"iname": "Health Nuts Cereal", "type": "grain", "texture": preload("res://Assets/items/grains/health nuts cereal.png"), "paid": false, "cost":5.50, "iposition": Vector2(550,-435), "desc": "This is The Worst cereal because it has nuts. Mom likes it though.",},
		{"iname": "Spaghetti", "type": "grain", "texture": preload("res://Assets/items/grains/spaghetti.png"), "paid": false, "cost":2.79, "iposition": Vector2(1950,60), "desc": "A normal pasta.",},
		{"iname": "White Bread", "type": "grain", "texture": preload("res://Assets/items/grains/white bread.png"), "paid": false, "cost":2.29, "iposition": Vector2(700,-130), "desc": "Unnaturally soft and pillowy, but in a good way.",},
		{"iname": "White Rice", "type": "grain", "texture": preload("res://Assets/items/grains/white rice.png"), "paid": false, "cost":2.50, "iposition": Vector2(1400,-130), "desc": "This is good if you put a lot of other stuff on top of it.",},
		{"iname": "Whole Wheat Bread", "type": "grain", "texture": preload("res://Assets/items/grains/whole wheat bread.png"), "paid": false, "cost":4.50, "iposition": Vector2(920,-300), "desc": "The slices are really thick and they have the little nuts and oats on top.",},
	]

	#dairy aisle
	dairy_aisle_items = [
		{"iname": "Eggs", "type": "dairy", "texture": preload("res://Assets/items/dairy/eggs.png"), "paid": false, "cost":3.00, "iposition": Vector2(2250,-120), "desc": "You checked to make sure they're not cracked.",},
		{"iname": "Fancy Eggs", "type": "dairy", "texture": preload("res://Assets/items/dairy/fancy eggs.png"), "paid": false, "cost":5.00, "iposition": Vector2(2300,-620), "desc": "These ones are brown which I think means they're better somehow?",},
		{"iname": "Oat Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/oat milk.png"), "paid": false, "cost":4.00, "iposition": Vector2(400,-300), "desc": "Mom puts oat milk in her coffee sometimes. But only at the coffee shop.",},
		{"iname": "Organic Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/organic milk.png"), "paid": false, "cost":4.00, "iposition": Vector2(0,50), "desc": "Whoa, the cow looks happier on this one. That probably means something.",},
		{"iname": "Whole Milk", "type": "dairy", "texture": preload("res://Assets/items/dairy/whole milk.png"), "paid": false, "cost":2.00, "iposition": Vector2(0,-290), "desc": "You don't really like drinking milk but it's good for cereal and stuff.",},
	]

	#produce aisle
	produce_aisle_items = [
		{"iname": "Apple", "type": "produce", "texture": preload("res://Assets/items/produce/apple.png"), "paid": false, "cost":1.00, "iposition": Vector2(1550,-150), "desc": "You're always a little worried there will be a worm inside. There hasn't been before, but like... maybe...",},
		{"iname": "Orange", "type": "produce", "texture": preload("res://Assets/items/produce/orange.png"), "paid": false, "cost":1.49, "iposition": Vector2(1200,-180), "desc": "Surprisingly a lot of work to eat.",},
		{"iname": "Red Onion", "type": "produce", "texture": preload("res://Assets/items/produce/red onion.png"), "paid": false, "cost":0.75, "iposition": Vector2(500,0), "desc": "This one makes your eyes water like crazy when Mom cuts it up.",},
		{"iname": "Spinach", "type": "produce", "texture": preload("res://Assets/items/produce/spinach.png"), "paid": false, "cost":4.00, "iposition": Vector2(2600,-150), "desc": "It's spinch.",},
		{"iname": "White Onion", "type": "produce", "texture": preload("res://Assets/items/produce/white onion.png"), "paid": false, "cost":0.89, "iposition": Vector2(700,0), "desc": "Mom just said onion... So it's probably this one, right?",},
	]

	#meat
	meat_aisle_items = [
		{"iname": "Chicken Breasts", "type": "meat", "texture": preload("res://Assets/items/meat/chicken breasts.png"), "paid": false, "cost":11.99, "iposition": Vector2(1500,-280), "desc": "Ew, why does it have the little white veins?",},
		{"iname": "Ground Beef", "type": "meat", "texture": preload("res://Assets/items/meat/ground beef.png"), "paid": false, "cost":13.00, "iposition": Vector2(300,-280), "desc": "It looks kinda gross like this but it's really good in spaghetti and stuff.",},
		{"iname": "Salmon Filet", "type": "meat", "texture": preload("res://Assets/items/meat/salmon filet.png"), "paid": false, "cost":14.99, "iposition": Vector2(2150,-280), "desc": "Delicious fishes.",},
		{"iname": "Tofu", "type": "meat", "texture": preload("res://Assets/items/meat/tofu.png"), "paid": false, "cost":3.49, "iposition": Vector2(2700,-580), "desc": "Why was this in the meat aisle?",},
	]

	#frozen
	frozen_aisle_items = [
		{"iname": "Frozen Chicken Nuggets", "type": "frozen", "texture": preload("res://Assets/items/frozen/frozen chicken nuggets.png"), "paid": false, "cost":11.50, "iposition": Vector2(1400,70), "desc": "Way better than plain old chicken.",},
		{"iname": "Frozen Chicken", "type": "frozen", "texture": preload("res://Assets/items/frozen/frozen chicken.png"), "paid": false, "cost":10.00, "iposition": Vector2(1100,70), "desc": "An economical choice.",},
		{"iname": "Vanilla Ice Cream", "type": "frozen", "texture": preload("res://Assets/items/frozen/vanilla ice cream.png"), "paid": false, "cost":5.00, "iposition": Vector2(2000,-140), "desc": "Try saying vanilla bean ice cream five times fast. ...Not that it's hard or anything, it's just fun that it rhymes.",},
	]

	#snack aisle
	snack_aisle_items = [
		{"iname": "Boring Chips", "type": "snack", "texture": preload("res://Assets/items/snack/boring chips.png"), "paid": false, "cost":4.00, "iposition": Vector2(750,-280), "desc": "What's the point of a chip if it's not exploding with flavor?",},
		{"iname": "Chipz", "type": "snack", "texture": preload("res://Assets/items/snack/chipz.png"), "paid": false, "cost":3.00, "iposition": Vector2(380,50), "desc": "Chipz is the best and coolest chip, because there's a z at the end. That's what all the ads say at least.",},
		{"iname": "Choco Bar", "type": "snack", "texture": preload("res://Assets/items/snack/choco bar.png"), "paid": false, "cost":2.00, "iposition": Vector2(1900,-550), "desc": "Mom always says cats aren't supposed to eat chocolate... But cats also aren't supposed to wear clothes and go to the grocery store.",},
		{"iname": "Soda", "type": "snack", "texture": preload("res://Assets/items/snack/soda.png"), "paid": false, "cost":1.50, "iposition": Vector2(2250,70), "desc": "Delicious carbonation.",},
	]


#HUD management
	budget_value = 30.00
	cart_value = 00.00

#variables for checking out/endings/dialogue

	dialogue_active = false
	has_checked_out = false
	ending_state = "empty"
	ending_checklist = {
		"eggs" : false,
		"milk" : false,
		"cereal" : false,
		"protein" : false,
		"bread" : false,
		"fruit" : false,
		"onion" : false,
		"grain" : false,
		"treat" : false,
	}
	ending_checklist_count = {
		"eggs" : 0,
		"milk" : 0,
		"cereal" : 0,
		"protein" : 0,
		"bread" : 0,
		"fruit" : 0,
		"onion" : 0,
		"grain" : 0,
		"treat" : 0,
	}
	
	nuggy = false
	tofu = false
	spinach = false
	white = false
	red = false

func main_scene_return():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func roll_credits():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
