extends Node2D

@export var camera_limit_left = -10000000.0
@export var camera_limit_right = -400.0
@export var camera_limit_top = -10000000.0
@export var camera_limit_bottom = 400.0
@onready var checkout_area = $CheckoutArea
@onready var scene_transition = $SceneTransition

func _ready():
	#set player position if reentering scene
	if Global.last_main_position != Vector2(0,0): #make sure it's not the default value
		$Player.position = Global.last_main_position
		$Player.position.y = Global.player_height
		if Global.player_direction == true:
			$Player/PlayerSprite.flip_h = true
		else:
			$Player/PlayerSprite.flip_h = false
	
	$Player/Camera2D.limit_left = camera_limit_left
	$Player/Camera2D.limit_right = camera_limit_right
	$Player/Camera2D.limit_top = camera_limit_top
	$Player/Camera2D.limit_bottom = camera_limit_bottom
	await get_tree().create_timer(0.5).timeout
	$Player/Camera2D.position_smoothing_enabled = true
			
	#spawn item in global item array
	spawn_aisle_items()
	
func _process(_delta):
	Global.player_pos = $Player.position

func spawn_aisle_items():
	var aisle_items = Global.find_current_aisle()
	if aisle_items.size() > 0:
		for i in aisle_items:
			Global.spawn_item(i)
		Global.update_scene_items()
