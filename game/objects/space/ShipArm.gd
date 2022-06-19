extends Spatial

const _OrbShip : PackedScene = preload("res://objects/space/OrbShip.tscn")

const ROTATE_INCR : float = 6.0
const ROTATE_MAX : float = 3.0
const THRUST_INCR : float = 3.0
const THRUST_MAX : float = 1.5
const THRUST_DECR : float = 1.0
const BRAKE_SPEED : float = 4.0

onready var tween : Tween = $Tween

var ship : Spatial

var forwards_thrust : float = 0.0
var turn_speed : float = 0.0

func spawn_ship(spawn_point : Spatial) -> Spatial:
	ship = _OrbShip.instance()
	add_child(ship)
	ship.translation.x = -1.1
	ship.rotation_degrees.z = 90.0
	return ship

func stop() -> void:
	forwards_thrust = 0.0
	turn_speed = 0.0

func jump() -> void:
	tween.interpolate_property(ship, "translation", Vector3(-1.1, 0.0, 0.0), Vector3(-2.1, 0.0, 0.0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(ship, "translation", Vector3(-2.1, 0.0, 0.0), Vector3(-1.1, 0.0, 0.0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN, 0.5)
	tween.start()

func _physics_process(delta : float) -> void:
	if is_instance_valid(ship):
		if Input.is_action_pressed("left"):
			turn_speed -= ROTATE_INCR * delta
		elif Input.is_action_pressed("right"):
			turn_speed += ROTATE_INCR * delta
		else:
			turn_speed = move_toward(turn_speed, 0.0, ROTATE_INCR * delta)
		turn_speed = clamp(turn_speed, -ROTATE_MAX, ROTATE_MAX)
		ship.rotate_x(turn_speed * delta)
		
		ship.set_tilt(turn_speed * 15.0)
		
		if Input.is_action_pressed("up"):
			forwards_thrust += THRUST_INCR * delta
		elif Input.is_action_pressed("down"):
			forwards_thrust -= BRAKE_SPEED * delta
		else:
			forwards_thrust -= THRUST_DECR * delta
		forwards_thrust = clamp(forwards_thrust, 0.0, THRUST_MAX)
		global_transform = global_transform.rotated(ship.global_transform.basis.x.normalized(), forwards_thrust * delta)
		ship.set_thrust_scale(pow(forwards_thrust / THRUST_MAX, 2.0))
