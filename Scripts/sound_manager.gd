extends Node

@onready var fade_music_manager = $FadeMusicManager
@onready var walk_sound = $WalkSound
@onready var grocery_music = $GroceryMusic
@onready var grocery_ambience = $GroceryAmbience
@onready var jump_sound = $JumpSound
@onready var confirm_sound = $ConfirmSound
@onready var checklist_sound = $ChecklistSound


func play_walk_sound():
	walk_sound.pitch_scale = randf_range(.9, 1.1)
	walk_sound.play()

func play_grocery_sound():
	grocery_ambience.play()
	grocery_music.play()
	
func play_jump_sound():
	jump_sound.play()
	
func play_confirm_sound():
	confirm_sound.play()

func play_checklist_sound():
	checklist_sound.play()

func fade_grocery_sound():
	fade_music_manager.play("fade_grocery_sound")


func _on_fade_music_manager_animation_finished(anim_name):
	if anim_name == "fade_grocery_sound":
		grocery_ambience.stop()
		grocery_music.stop()
		grocery_ambience.volume_db = 0.0
		grocery_music.volume_db = 0.0
