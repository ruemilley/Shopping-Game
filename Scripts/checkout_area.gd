extends Node2D

@onready var cashier = $Cashier
@onready var blink_timer = $BlinkTimer
@onready var checkout_sound = $CheckoutSound

func _ready():
	Events.started_talking.connect(_on_started_talking)
	Events.finished_talking.connect(_on_finished_talking)
	
	
func _process(_delta):
	if Global.player_pos.x < -1135:
		cashier.flip_h = true
	else:
		cashier.flip_h = false

func _on_blink_timer_timeout():
	cashier.play("blink")
	blink_timer.wait_time = randi_range(3,10)


func play_checkout_sound():
	checkout_sound.play()

func _on_started_talking(talker):
	if talker == "Shop Clerk":
		blink_timer.paused = true
		cashier.play("talk")
	
func _on_finished_talking():
	await cashier.animation_looped
	cashier.play("idle")
	blink_timer.paused = false
