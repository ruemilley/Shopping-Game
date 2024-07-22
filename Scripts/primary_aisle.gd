extends Node2D


func _ready():
	#spawn item in global item array
	spawn_aisle_items()
	
	#set player position if reentering scene
	if Global.last_main_position != Vector2(0,0): #make sure it's not the default value
		$Player.position = Global.last_main_position
		$Player.position.y = Global.player_height
		if Global.player_direction == true:
			$Player/AnimatedSprite2D.flip_h = true
		else:
			$Player/AnimatedSprite2D.flip_h = false

func spawn_aisle_items():
	var aisle_items = Global.find_current_aisle()
	if aisle_items.size() > 0:
		for i in aisle_items:
			Global.spawn_item(i)
		Global.update_scene_items()
