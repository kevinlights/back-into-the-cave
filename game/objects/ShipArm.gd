extends Spatial

const ROTATE_INCR : float = 6.0
const ROTATE_MAX : float = 3.0
const THRUST_INCR : float = 3.0
const THRUST_MAX : float = 1.5
const THRUST_DECR : float = 2.0

var ship : Spatial

var forwards_thrust : float = 0.0
var turn_speed : float = 0.0

func stop() -> void:
	forwards_thrust = 0.0
	turn_speed = 0.0

func _physics_process(delta : float) -> void:
	if is_instance_valid(ship):
		if Input.is_action_pressed("ui_left"):
			turn_speed -= ROTATE_INCR * delta
		elif Input.is_action_pressed("ui_right"):
			turn_speed += ROTATE_INCR * delta
		else:
			turn_speed = move_toward(turn_speed, 0.0, ROTATE_INCR * delta)
		turn_speed = clamp(turn_speed, -ROTATE_MAX, ROTATE_MAX)
		ship.rotate_x(turn_speed * delta)
		
		ship.set_tilt(turn_speed * 15.0)
		
		if Input.is_action_pressed("ui_up"):
			forwards_thrust += THRUST_INCR * delta
		else:
			forwards_thrust -= THRUST_DECR * delta
		forwards_thrust = clamp(forwards_thrust, 0.0, THRUST_MAX)
		global_transform = global_transform.rotated(ship.global_transform.basis.x.normalized(), forwards_thrust * delta)
		ship.set_thrust_scale(pow(forwards_thrust / THRUST_MAX, 2.0))
