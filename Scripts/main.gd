extends Node2D

func _ready():
	#set player position if reentering scene
	if Global.last_main_position != Vector2(0,0): #make sure it's not the default value
		$Player.position = Global.last_main_position
		$Player.position.y = 0.0 #put you on the ground in case you were jumping when you went through the door
