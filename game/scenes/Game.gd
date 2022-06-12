extends Spatial

const CAMERA_MOVE_SPEED : float = 5.0

onready var camera_arm : Spatial = $CameraArm
onready var camera : Camera = $CameraArm/Camera
onready var cave_scene : Node2D = $Viewport/CaveScene
onready var ship_arm : Spatial = $ShipArm
onready var ship_camera : Spatial = $ShipArm/Ship/Camera

enum State {INTRO, SHIP_SCENE, CAVE_SCENE}

var current_state : int = State.INTRO

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "intro":
		current_state = State.SHIP_SCENE

func _physics_process(delta : float) -> void:
	if current_state == State.SHIP_SCENE:
		camera.global_transform = camera.global_transform.interpolate_with(ship_camera.global_transform, CAMERA_MOVE_SPEED * delta)
		camera.fov = lerp(camera.fov, ship_camera.fov, CAMERA_MOVE_SPEED * delta)
	elif current_state == State.CAVE_SCENE:
		camera_arm.rotation.x = lerp_angle(camera_arm.rotation.x, 0.0, CAMERA_MOVE_SPEED * delta)
		camera_arm.rotation.z = lerp_angle(camera_arm.rotation.z, 0.0, CAMERA_MOVE_SPEED * delta)
		var player_rotate : float = (PI * 1.5) - (cave_scene.player_pos.x * PI * 2.0)
		camera_arm.rotation.y = lerp_angle(camera_arm.rotation.y, player_rotate, CAMERA_MOVE_SPEED * delta)

func _ready() -> void:
	$AnimationPlayer.play("intro")
	$AnimationPlayer.seek(15.0)
