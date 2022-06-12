extends Spatial

const CAMERA_MOVE_SPEED : float = 2.0

onready var camera_arm : Spatial = $CameraArm
onready var cave_scene : Node2D = $Viewport/CaveScene

enum State {INTRO, CAVE_SCENE}

var current_state : int = State.INTRO

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "intro":
		current_state = State.CAVE_SCENE

func _physics_process(delta : float) -> void:
	if current_state == State.CAVE_SCENE:
		camera_arm.rotation.x = lerp_angle(camera_arm.rotation.x, 0.0, CAMERA_MOVE_SPEED * delta)
		camera_arm.rotation.z = lerp_angle(camera_arm.rotation.z, 0.0, CAMERA_MOVE_SPEED * delta)
		var player_rotate : float = (PI * 1.5) - (cave_scene.player_pos.x * PI * 2.0)
		camera_arm.rotation.y = lerp_angle(camera_arm.rotation.y, player_rotate, CAMERA_MOVE_SPEED * delta)

func _ready() -> void:
	$AnimationPlayer.play("intro")
	$AnimationPlayer.seek(20.0)
