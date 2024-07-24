extends Control

func _on_track_1_pressed():
	GameManager.track_scene = preload ("res://world/scenes/Levels/track1.tscn")
	get_tree().change_scene_to_file("res://ui/scenes/play_menu.tscn")
	

func _on_track_2_pressed():
	GameManager.track_scene = preload ("res://world/scenes/Levels/art_test_level.tscn")
	get_tree().change_scene_to_file("res://ui/scenes/play_menu.tscn")
	

func _on_back_pressed():
	get_tree().change_scene_to_file("res://ui/scenes/main_menu.tscn")

