extends Control

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://ui/scenes/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://ui/scenes/levelselect2.tscn")
