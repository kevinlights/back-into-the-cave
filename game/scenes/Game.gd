extends Spatial

const _OrbShip : PackedScene = preload("res://objects/OrbShip.tscn")

const CAMERA_MOVE_SPEED : float = 3.0

onready var camera_arm : Spatial = $CameraArm
onready var camera : Camera = $CameraArm/Camera
onready var cave_scene : Node2D = $Viewport/CaveScene
onready var ship_arm : Spatial = $ShipArm
onready var timer_respawn_orb_ship : Timer = $Timer_RespawnOrbShip
onready var particles_stars : Particles = $Particles_Stars
onready var world_environment : WorldEnvironment = $WorldEnvironment
onready var pause_menu : Control = $CanvasLayer/PauseMenu
onready var subtitle_controller : Node = $SubtitleController
onready var music_controller : Node = $MusicController

enum State {INTRO, SHIP_SCENE, CAVE_SCENE}

var current_state : int = State.INTRO
var ship : Spatial
onready var level : Spatial = $Level1

func apply_graphics_settings() -> void:
	world_environment.environment.glow_enabled = true if Settings.glow_amount > 0 else false
	match Settings.glow_amount:
		1: world_environment.environment.glow_intensity = 0.4
		2: world_environment.environment.glow_intensity = 0.8
		3: world_environment.environment.glow_intensity = 1.6
	world_environment.environment.glow_bicubic_upscale = true if Settings.glow_quality >= 1 else false
	world_environment.environment.glow_high_quality = true if Settings.glow_quality >= 2 else false

func apply_star_quantity() -> void:
	particles_stars.visible = Settings.star_density > 0
	match Settings.star_density:
		0: particles_stars.amount = 1
		1: particles_stars.amount = 2500
		2: particles_stars.amount = 5000
		3: particles_stars.amount = 10000
		4: particles_stars.amount = 50000
	particles_stars.restart()

func spawn_orb_ship() -> void:
	ship_arm.rotation = level.spawn_point.rotation
	ship = _OrbShip.instance()
	ship_arm.add_child(ship)
	ship.translation.x = -1.1
	ship.rotation_degrees.z = 90.0
	ship_arm.ship = ship
	ship.connect("destroyed", self, "_on_orb_ship_destroyed")

func _on_orb_ship_destroyed() -> void:
	ship_arm.stop()
	timer_respawn_orb_ship.start()

func _on_Key_collector() -> void:
	return
	current_state = State.CAVE_SCENE
	$Inside_2D.show()

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "intro":
		current_state = State.SHIP_SCENE
		spawn_orb_ship()
		subtitle_controller.play_scene("scene2")

func _on_Timer_RespawnOrbShip_timeout() -> void:
	spawn_orb_ship()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.pause()
		get_tree().set_input_as_handled()

func _physics_process(delta : float) -> void:
	if current_state == State.SHIP_SCENE and is_instance_valid(ship):
		camera.global_transform = camera.global_transform.interpolate_with(ship.camera.global_transform, CAMERA_MOVE_SPEED * delta)
		camera.fov = lerp(camera.fov, ship.camera.fov, CAMERA_MOVE_SPEED * delta)
	elif current_state == State.CAVE_SCENE:
		camera.fov = lerp(camera.fov, 35.0, CAMERA_MOVE_SPEED * delta)
		camera.translation = lerp(camera.translation, Vector3(-5.0, 0.0, 0.0), CAMERA_MOVE_SPEED * delta)
		camera.rotation_degrees = lerp(camera.rotation_degrees, Vector3(0.0, -90.0, 0.0), CAMERA_MOVE_SPEED * delta)
		camera_arm.translation = lerp(camera_arm.translation, Vector3.ZERO, CAMERA_MOVE_SPEED * delta)
		camera_arm.rotation.x = lerp_angle(camera_arm.rotation.x, 0.0, CAMERA_MOVE_SPEED * delta)
		camera_arm.rotation.z = lerp_angle(camera_arm.rotation.z, 0.0, CAMERA_MOVE_SPEED * delta)
		var player_rotate : float = (PI * 1.5) - (cave_scene.player_pos.x * PI * 2.0)
		camera_arm.rotation.y = lerp_angle(camera_arm.rotation.y, player_rotate, CAMERA_MOVE_SPEED * delta)

func _ready() -> void:
	apply_graphics_settings()
	apply_star_quantity()
	yield(get_tree(), "idle_frame")
	music_controller.play_track("opening")
	$AnimationPlayer.play("intro")
