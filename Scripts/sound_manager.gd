extends Node

@onready var fade_music_manager = $FadeMusicManager
@onready var walk_sound = $WalkSound
@onready var grocery_music = $GroceryMusic
@onready var grocery_ambience = $GroceryAmbience
@onready var jump_sound = $JumpSound
@onready var confirm_sound = $ConfirmSound
@onready var checklist_sound = $ChecklistSound
@onready var general_theme_music = $GeneralThemeMusic
@onready var run_music = $RunMusic

func play_walk_sound():
	walk_sound.pitch_scale = randf_range(.9, 1.1)
	walk_sound.play()

func play_grocery_sound():
	if general_theme_music.playing == true:
		fade_general_theme_music()
	grocery_ambience.play()
	grocery_music.play()
	
func play_jump_sound():
	jump_sound.play()
	
func play_confirm_sound():
	confirm_sound.play()

func play_checklist_sound():
	checklist_sound.play()
	
func play_run_music():
	run_music.play()
	
func play_general_theme_music():
	if grocery_music.playing == true:
		fade_grocery_sound()
	general_theme_music.play()
	
func fade_general_theme_music():
	fade_music_manager.play("fade_general_theme_music")

func fade_grocery_sound():
	fade_music_manager.play("fade_grocery_sound")
	
func fade_run_music():
	fade_music_manager.play("fade_run_music")

func _on_fade_music_manager_animation_finished(anim_name):
	if anim_name == "fade_grocery_sound":
		grocery_ambience.stop()
		grocery_music.stop()
		grocery_ambience.volume_db = 0.0
		grocery_music.volume_db = 0.0
	if anim_name == "fade_general_theme_music":
		general_theme_music.stop()
		general_theme_music.volume_db = 0.0
	if anim_name == "fade_run_music":
		run_music.stop()
		run_music.volume_db = 0.0
