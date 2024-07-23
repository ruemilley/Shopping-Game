extends Node2D

@export var camera_limit_left = -10000000.0
@export var camera_limit_right = 10000000.0
@export var camera_limit_top = -10000000.0
@export var camera_limit_bottom = 10000000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_aisle_items()
		
	$Player.position.y = Global.player_height
	if Global.player_direction == true:
		$Player/AnimatedSprite2D.flip_h = true
	else:
		$Player/AnimatedSprite2D.flip_h = false
	
	$Player/Camera2D.limit_left = camera_limit_left
	$Player/Camera2D.limit_right = camera_limit_right
	$Player/Camera2D.limit_top = camera_limit_top
	$Player/Camera2D.limit_bottom = camera_limit_bottom
	
	
func spawn_aisle_items():
	var aisle_items = Global.find_current_aisle()
	if aisle_items.size() > 0:
		for i in aisle_items:
			Global.spawn_item(i)
		Global.update_scene_items()
