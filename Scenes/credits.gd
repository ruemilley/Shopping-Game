extends Control


func _on_button_pressed():
	Global.reset_game_state()
	SoundManager.play_confirm_sound()
	if SoundManager.run_music.playing == true:
		SoundManager.fade_run_music()
	Global.main_scene_return()
