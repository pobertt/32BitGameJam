extends Control

#127.0.0.1
var address = "192.168.0.27"
@export var port = 8910
var peer

@onready var host = $host
@onready var join = $join
@onready var startgame = $startgame

func _ready():
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	if "--server" in OS.get_cmdline_args():
		_host_game()
	
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
	_send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
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
	
@rpc("any_peer","call_local")
func _start_game():
	var scene = load("res://world/scenes/world.tscn").instantiate()
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
	
func _on_host_button_down():
	_host_game()
	_send_player_information($LineEdit.text, multiplayer.get_unique_id())

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_startgame_button_down():
	_start_game.rpc()



