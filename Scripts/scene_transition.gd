extends CanvasLayer

@onready var color_rect := $ColorRect
@onready var animation_player := $AnimationPlayer
@export var is_black := false

func _ready():
	if is_black == true:
		color_rect.color = Color(0,0,0,255)
	else:
		color_rect.color = Color(0,0,0,0)


func fade_to_black():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
func fade_to_normal():
	animation_player.play("fade_to_normal")
	await animation_player.animation_finished
