extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/scenes/main_menu.tscn")
	multiplayer.peer_disconnected.connect(GameManager.players.id)

func _on_quit_pressed():
	get_tree().quit()
