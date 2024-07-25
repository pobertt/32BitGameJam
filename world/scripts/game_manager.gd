extends Node

var players = {}

@onready var track_scene : PackedScene

var laps : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, 0.5)
	
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
