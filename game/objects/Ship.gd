extends Spatial

onready var thruster : Spatial = $Ship/Thruster

func set_thrust_scale(amount : float) -> void:
	thruster.scale = Vector3(amount * rand_range(0.9, 1.1), amount * rand_range(0.9, 1.1), amount * rand_range(1.0, 2.0))
