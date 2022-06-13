extends Spatial

class_name OrbShip

const _Explosion : PackedScene = preload("res://objects/Explosion.tscn")

onready var mesh : MeshInstance = $Mesh
onready var thruster : Spatial = $Mesh/Thruster

signal destroyed

func set_thrust_scale(amount : float) -> void:
	thruster.scale = Vector3(amount * rand_range(0.9, 1.1), amount * rand_range(0.9, 1.1), amount * rand_range(1.0, 2.0))

func set_tilt(angle : float) -> void:
	mesh.rotation_degrees.z = angle

func get_hit() -> void:
	var explosion : Spatial = _Explosion.instance()
	explosion.global_transform = self.global_transform
	get_tree().root.add_child(explosion)
	hide()
	emit_signal("destroyed")
