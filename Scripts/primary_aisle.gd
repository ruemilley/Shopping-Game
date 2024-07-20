extends Node2D


func _ready():
	#spawn item in global item array
	if Global.primary_aisle_items.size() > 0:
		for i in Global.primary_aisle_items:
			Global.spawn_item(i)
		Global.update_scene_items()
	
	#set player position if reentering scene
	if Global.last_main_position != Vector2(0,0): #make sure it's not the default value
		$Player.position = Global.last_main_position
		$Player.position.y = Global.player_height
		if Global.player_direction == true:
			$Player/AnimatedSprite2D.flip_h = true
		else:
			$Player/AnimatedSprite2D.flip_h = false

