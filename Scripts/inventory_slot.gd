extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var usage_panel = $UsagePanel

#Slot Icon
var item = null


func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited():
	details_panel.visible = false

# create an empty slot
func set_empty():
	icon.texture = null
	quantity_label = ""

# add a new item
func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	


func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 25)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["name"])
		usage_panel.visible = false
