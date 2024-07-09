extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.aisle_items.size() > 0:
		for i in Global.aisle_items:
			Global.spawn_item(i)
		Global.update_scene_items()
	$Player.position.y = Global.player_height
	if Global.player_direction == true:
		$Player/AnimatedSprite2D.flip_h = true
	else:
		$Player/AnimatedSprite2D.flip_h = false
	print(Global.primary_aisle_items)
	
