extends Node2D

@onready var cashier = $Cashier
@onready var blink_timer = $BlinkTimer

func connect_dialogue_ended():
	var dialogue_label = %DialogueLabel
	dialogue_label.finished_typing.connect(end_cashier_talking)
	
func _process(delta):
	if Global.player_pos.x < -1135:
		cashier.flip_h = true
	else:
		cashier.flip_h = false

func _on_blink_timer_timeout():
	cashier.play("blink")
	blink_timer.wait_time = randi_range(3,10)

#function that is called when dialogue is triggered, need to figure out how to implement this

func cashier_talking():
	blink_timer.paused = true
	cashier.play("talk")
	
func end_cashier_talking(_resource: DialogueResource):
	cashier.play("idle")
	blink_timer.paused = false
