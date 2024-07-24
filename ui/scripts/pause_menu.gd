extends Control

func _on_resume_pressed():
	self.hide()
	get_tree().paused = false

func _on_quit_pressed():
	get_tree().quit()
