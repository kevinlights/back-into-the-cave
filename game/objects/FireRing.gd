extends Area

func _on_FireRing_body_entered(body) -> void:
	if body is OrbShip:
		body.get_hit()
