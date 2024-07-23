extends RichTextLabel

func _ready():
	#check inventory size, iterate through the inventory and cross off items on our checklist
	if Global.inventory.size() > 0:
		for i in Global.inventory:
			if i != null:
				check_items(i)

func check_items(item_name):
	#cross off items function
	if item_name["iname"] == text:
		print("item checked")
		$Crossout.visible = true
	else:
		pass

func uncheck_items(item_name):
	#undo crossout if we drop the item. this function is called in the global script
	if item_name == text:
		print("item unchecked")
		$Crossout.visible = false
	else:
		pass	
