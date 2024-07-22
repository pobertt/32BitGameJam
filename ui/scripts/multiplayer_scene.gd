extends Control

#
#var address = "192.168.0.27"
#var ip_address :String

var address = "0"
@export var port = 8910
var peer

var host_pressed : bool = false

@onready var host = $VBoxContainer/host
@onready var join = $VBoxContainer/join
@onready var startgame = $VBoxContainer/startgame

var game_scene = preload("res://world/scenes/track1.tscn")

func _ready():
	#if OS.has_feature("windows"):
		#if OS.get_environment("COMPUTERNAME"):
			#ip_address =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	#elif OS.has_feature("x11"):
		#if OS.get_environment("HOSTNAME"):
			#ip_address =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	#elif OS.has_feature("OSX"):
		#if OS.get_environment("HOSTNAME"):
			#ip_address =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
		
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	if "--server" in OS.get_cmdline_args():
		_host_game()
	
	address = get_local_ip()

func _peer_connected(id):
	print("Player Connected: " + str(id))

func _peer_disconnected(id):
	print("Player Disconnected: " + str(id))
	GameManager.players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
func _connected_to_server():
	print("Connected to Server!")
	_send_player_information.rpc_id(1, $NameText.text, multiplayer.get_unique_id())
	
func _connection_failed():
	print("Connection failed :(")
	
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

@rpc("any_peer")
func _set_IP(newAddress):
	address = newAddress

@rpc("any_peer","call_local")
func _start_game():
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")
	print(str(IP.get_local_addresses()))
	
func _on_host_button_down():
	#_set_IP($AddressText.text)
	host_pressed = true
	_host_game()
	_send_player_information("", multiplayer.get_unique_id())
	
func _on_join_button_down():
	#_set_IP($AddressText.text) 
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_startgame_button_down():
	if host_pressed == true:
		_start_game.rpc()
		print(address)

func get_local_ip() -> String:
	var local_ip = IP.get_local_addresses()
	for ip in local_ip:
		if ip.begins_with("192.168.") or ip.begins_with("10.") or ip.begins_with("172."):
			return ip
	return ""

func _on_back_pressed():
	get_tree().change_scene_to_file("res://ui/scenes/play_menu.tscn")
