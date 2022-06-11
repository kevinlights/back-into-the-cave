extends Spatial

onready var camera_arm : Spatial = $CameraArm

func _physics_process(delta : float) -> void:
	return
	camera_arm.rotate_z(delta * 0.06125)
	camera_arm.rotate_x(delta * 0.15)
	camera_arm.rotate_y(delta * 0.25)

func _ready() -> void:
	$AnimationPlayer.play("default")
