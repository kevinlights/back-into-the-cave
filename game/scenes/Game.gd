extends Spatial

const LEVELS : Array = [
	preload("res://levels/space/Level1.tscn"),
	preload("res://levels/space/Level2.tscn"),
	preload("res://levels/space/Level3.tscn"),
]

const CAMERA_MOVE_SPEED : float = 3.0

enum State {INTRO, SHIP_SCENE, CAVE_SCENE}

onready var camera_arm : Spatial = $CameraArm
onready var camera : Camera = $CameraArm/Camera
onready var cave_scene : Node2D = $Viewport_CaveScene/CaveScene
onready var ship_arm : Spatial = $ShipArm
onready var timer_respawn_orb_ship : Timer = $Timer_RespawnOrbShip
onready var particles_stars : Particles = $Particles_Stars
onready var world_environment : WorldEnvironment = $WorldEnvironment
onready var pause_menu : Control = $CanvasLayer/PauseMenu
onready var subtitle_controller : Node = $SubtitleController
onready var music_controller : Node = $MusicController
onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var tween : Tween = $Tween

var ship : Spatial
var level : Spatial

var current_state : int = State.INTRO
var current_level : int = 0
var stop_on_level : int = 3
var keys_collected : int = 0

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
	ship = ship_arm.spawn_ship(level.spawn_point)
	ship.connect("destroyed", self, "_on_orb_ship_destroyed")

func spawn_level() -> void:
	if is_instance_valid(level):
		level.queue_free()
	level = LEVELS[current_level].instance()
	add_child(level)

func start_level() -> void:
	keys_collected = 0
	spawn_level()
	spawn_orb_ship()

func restart_level() -> void:
	get_tree().call_group("disappearer", "disappear")
	yield(get_tree().create_timer(1.5), "timeout")
	start_level()

func transition_to_cave_scene() -> void:
	tween.interpolate_property(camera_arm, "rotation_degrees", null, Vector3(0.0, 144.007, 0.0), 8.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(camera_arm, "translation", null, Vector3(0.0, 0.0, 0.0), 8.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(camera, "rotation_degrees", null, Vector3(0.0, -90.0, 0.0), 8.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(camera, "translation", null, Vector3(-5.0, 0.0, 0.0), 8.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(camera, "fov", null, 35.0, 8.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func next_level() -> void:
	get_tree().call_group("disappearer", "disappear")
	yield(get_tree().create_timer(1.5), "timeout")
	current_level += 1
	if current_level != stop_on_level:
		start_level()
	else:
		if current_level == 3:
			level.queue_free()
			music_controller.play_track("cave")
			transition_to_cave_scene()
			yield(tween, "tween_all_completed")
			current_state = State.CAVE_SCENE
			cave_scene.spawn_level()
			cave_scene.fade_in()
			$Inside_2D.show()

func _on_orb_ship_destroyed() -> void:
	ship_arm.stop()
	restart_level()

func _on_key_collected() -> void:
	keys_collected += 1
	if keys_collected >= 3:
		next_level()
		keys_collected = 0

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "intro":
		current_state = State.SHIP_SCENE
		spawn_level()
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
	yield(get_tree().create_timer(0.5), "timeout")
	music_controller.play_track("opening")
	anim_player.play("intro")
	anim_player.seek(18.0)
