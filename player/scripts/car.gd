extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300

var eDelta = 0

@onready var camera_pivot = $SubViewportContainer/SubViewport/CameraPivot
@onready var camera_3d = $SubViewportContainer/SubViewport/CameraPivot/Camera3D
@onready var reverse_camera = $SubViewportContainer/SubViewport/CameraPivot/ReverseCamera

var look_at

# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	eDelta = delta
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera_3d.current = true
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 2.5)
		engine_force = Input.get_axis("down", "up") * ENGINE_POWER
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
		camera_3d.look_at(look_at)
		reverse_camera.look_at(look_at)
		_check_camera_switch()
		
func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > -1:
		camera_3d.current = true
	else:
		reverse_camera.current = true
