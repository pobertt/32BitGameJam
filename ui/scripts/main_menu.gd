extends Control

var game_scene = preload("res://world/scenes/track1.tscn")

func _on_singleplayer_pressed():
	_send_player_information("singleplayername", multiplayer.get_unique_id())
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	#get_tree().change_scene_to_file("res://world/scenes/track1.tscn")

func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://world/scenes/multiplayer_scene.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://world/scenes/settings.tscn")


func _on_quit_pressed():
	get_tree().quit()

@rpc("any_peer")
func _send_player_information(name, id):
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score" : 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.players:
			_send_player_information.rpc(GameManager.players[i].name, i)
