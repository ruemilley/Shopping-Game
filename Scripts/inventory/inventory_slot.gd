extends Control

@onready var icon = %ItemIcon
@onready var drop_button = %DropButton

#Slot Icon
var item = null



# create an empty slot
func set_empty():
	icon.texture = null

# add a new item
func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	drop_button.visible = true
	


func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 25)
		Global.drop_item(item, drop_position + drop_offset)
		drop_button.visible = false
		Global.remove_item(item["iname"],item["type"])



func _on_mouse_entered():
	if item != null:
		Events.inventory_focus.emit(item["iname"],item["cost"],item["item_desc"])


func _on_mouse_exited():
	if item != null:
		Events.inventory_focus_exit.emit()
	
