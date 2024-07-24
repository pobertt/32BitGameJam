extends Control


func _on_resume_pressed():
	get_tree().paused = false
	self.hide()

func _on_quit_pressed():
	get_tree().quit()
