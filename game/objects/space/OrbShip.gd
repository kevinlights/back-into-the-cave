extends Spatial

class_name OrbShip

const _Explosion : PackedScene = preload("res://objects/space/Explosion.tscn")

onready var mesh : MeshInstance = $Mesh
onready var thruster : Spatial = $Mesh/Thruster
onready var glowything : Spatial = $Glowything
onready var audio_engine : AudioStreamPlayer3D = $Audio_Engine
onready var camera : Camera = $Camera
onready var tween : Tween = $Tween

var disappearing : bool = false

signal destroyed

func set_thrust_scale(amount : float) -> void:
	thruster.scale = Vector3(amount * rand_range(0.9, 1.1), amount * rand_range(0.9, 1.1), amount * rand_range(1.0, 2.0))
	audio_engine.pitch_scale = range_lerp(amount, 0.0, 1.0, 1.0, 2.0)
	audio_engine.unit_db = range_lerp(amount, 0.0, 1.0, -30.0, -10.0)

func set_tilt(angle : float) -> void:
	mesh.rotation_degrees.z = angle

func set_glow_amount(amount : float) -> void:
	glowything.get_surface_material(0).emission_energy = amount

func get_hit() -> void:
	if disappearing: return
	var explosion : Spatial = _Explosion.instance()
	explosion.global_transform = self.global_transform
	get_tree().root.add_child(explosion)
	emit_signal("destroyed")
	queue_free()

func jump() -> void:
	get_parent().jump() # janky hack, m8!

func disappear() -> void:
	if disappearing: return
	disappearing = true
	tween.interpolate_method(self, "set_glow_amount", 0.0, 3.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_method(self, "set_glow_amount", 3.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
	tween.start()
	yield(get_tree().create_timer(0.25), "timeout")
	mesh.hide()
	yield(tween, "tween_all_completed")
	queue_free()

func _ready() -> void:
	mesh.show()
	set_glow_amount(0.0)
