extends Spatial

const ROTATE_INCR : float = 6.0
const ROTATE_MAX : float = 3.0
const THRUST_INCR : float = 3.0
const THRUST_MAX : float = 2.0
const THRUST_DECR : float = 2.0

onready var turn_arm : Spatial = $TurnArm
onready var ship : Spatial = $TurnArm/Ship

var forwards_thrust : float = 0.0
var turn_speed : float = 0.0

func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("ui_left"):
		turn_speed -= ROTATE_INCR * delta
	elif Input.is_action_pressed("ui_right"):
		turn_speed += ROTATE_INCR * delta
	else:
		turn_speed = move_toward(turn_speed, 0.0, ROTATE_INCR * delta)
	turn_speed = clamp(turn_speed, -ROTATE_MAX, ROTATE_MAX)
	turn_arm.rotate_x(turn_speed * delta)
	
	ship.rotation_degrees.z = 90.0 + (turn_speed * 15.0)
	
	if Input.is_action_pressed("ui_up"):
		forwards_thrust += THRUST_INCR * delta
	else:
		forwards_thrust -= THRUST_DECR * delta
	forwards_thrust = clamp(forwards_thrust, 0.0, THRUST_MAX)
	var thrust_rotation : Vector3 = Vector3.UP \
		.rotated(Vector3.RIGHT, turn_arm.rotation.x)
	rotate(thrust_rotation, forwards_thrust * delta)
	ship.set_thrust_scale(pow(forwards_thrust / THRUST_MAX, 2.0))
