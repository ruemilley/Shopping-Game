extends Control

@onready var grid_container = $HBoxContainer/MarginContainer/GridContainer
@onready var item_name = %ItemName
@onready var item_price = %ItemPrice
@onready var item_description = %ItemDescription
@onready var checklist_button = %ChecklistButton
@onready var checklist_sound = $ChecklistSound


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_updated.connect(_on_inventory_updated)
	Events.inventory_focus.connect(_on_inventory_focus)
	Events.inventory_focus_exit.connect(_on_inventory_focus_exit)
	Events.my_checklist_button_pressed.connect(_on_my_checklist_button_pressed)
	Events.checklist_hidden.connect(_on_checklist_hidden)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()
	#add slots for each nventory position
	for item in Global.inventory:
		var slot = Global.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func _on_inventory_focus(iname,cost, desc):
	item_name.text = "[center][b]" + iname
	item_price.text = "[center]$" + str("%4.2f" % cost)
	item_description.text = "[center]" + desc
	
func _on_inventory_focus_exit():
	item_name.text = ""
	item_price.text = ""
	item_description.text = ""


func _on_close_button_pressed():
	Events.inventory_close_button_pressed.emit()

func _on_checklist_button_pressed():
	Events.my_checklist_button_pressed.emit()
	checklist_sound.playing = true
	checklist_button.disabled = true

func _on_my_checklist_button_pressed():
	checklist_sound.playing = true
	checklist_button.button_pressed = !checklist_button.button_pressed

func _on_checklist_hidden():
	checklist_sound.playing = true
	checklist_button.disabled = false
