extends Node2D

@onready var blink_timer = $BlinkTimer
@onready var blink_animation = $Blink
@onready var talk_animation = $Talk
@onready var look_up_animation = $LookUpAnimation

var pause_anim := false
var current_blink
var current_talk

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.started_talking.connect(_on_started_talking)
	Events.finished_talking.connect(_on_finished_talking)
	current_blink = "blink_ld"
	current_talk = "talk_ld"
	
func look_up():
	blink_timer.stop()
	$Blink.visible = false
	$Talk.visible = false
	current_blink ="blink_lu"
	current_talk ="talk_lu"
	look_up_animation.visible = true
	$Base.visible = false
	blink_animation.play(current_blink)
	look_up_animation.play("default")
	await look_up_animation.animation_finished

func _on_blink_timer_timeout():
	blink_animation.play(current_blink)
	blink_timer.wait_time = randi_range(3,10)
	
func _on_started_talking(_talker):
	if pause_anim != true:
		talk_animation.play(current_talk)

func _on_finished_talking():
	await talk_animation.animation_looped
	talk_animation.pause()

func force_up_anim():
	talk_animation.set_animation("talk_lu")
	

func _on_look_up_animation_animation_finished():
	$Base.texture = load("res://Assets/characters/mom/look up/mom_look_up_base.png")
	look_up_animation.visible = false
	$Base.visible = true
	blink_animation.visible = true
	talk_animation.visible = true
	blink_timer.start()
	
	
	
