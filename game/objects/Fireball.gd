extends Area

const ROTATE_SPEED : float = 1.0

func _on_Fireball_body_entered(body) -> void:
	if body is OrbShip:
		body.get_hit()

func _physics_process(delta : float) -> void:
	global_transform = global_transform.rotated(global_transform.basis.y.normalized(), ROTATE_SPEED * delta)
