extends Node3D

var camrot_h = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$horizontal/vertical/springArm/Camera.add_exception(get_parent())
	pass

func _input(event):
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$horizontal.rotation_degrees.y = camrot_h
