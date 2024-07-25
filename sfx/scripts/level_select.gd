extends Control

const level_btn = preload("res://ui/scenes/level_button.tscn")

@export_dir var dir_path 
@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready():
	_get_levels(dir_path)

func _get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print(file_name)
			_create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("error")
			
func _create_level_btn(lvl_path : String, lvl_name : String):
	var btn = level_btn.instantiate()
	btn.text = lvl_name.trim_suffix('.tscn').replace("_", " ")
	btn.level_path = lvl_path
	grid.add_child(btn)
