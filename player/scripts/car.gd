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
	if $MultiplayerSynchronizer.is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		look_at = global_position
		
		$SubViewportContainer.show()
	else:
		$SubViewportContainer.hide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !multiplayer.has_multiplayer_peer():
		return  # Exit if multiplayer is not active
	
	if $MultiplayerSynchronizer.is_multiplayer_authority():
		eDelta = delta
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 2.5)
			engine_force = Input.get_axis("down", "up") * ENGINE_POWER
			camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
			camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
			look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
			camera_3d.look_at(look_at)
			reverse_camera.look_at(look_at)
			_check_camera_switch()
			
			sync_state.rpc(global_position, global_rotation, linear_velocity)
	else:
		global_position = global_position.lerp(global_position, delta * 20.0)
			
func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > -1:
		camera_3d.current = true
	else:
		reverse_camera.current = true
		
@rpc("unreliable")
func sync_state(pos: Vector3, rot: Vector3, vel: Vector3):
	global_position = pos
	global_rotation = rot
	linear_velocity = vel

