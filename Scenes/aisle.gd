extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.aisle_items.size() > 0:
		for i in Global.aisle_items:
			Global.spawn_item(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
