extends Area

onready var particles : Particles = $Particles
onready var tween : Tween = $Tween

var collected : bool = false

func respawn() -> void:
	collected = false
	tween.interpolate_property(self, "scale", null, Vector3.ONE, 0.5)
	tween.start()

func _on_Key_body_entered(body) -> void:
	if collected: return
	if body is OrbShip:
		particles.emitting = true
		collected = true
		tween.interpolate_property(self, "scale", null, Vector3.ZERO, 0.5)
		tween.start()

func _physics_process(delta : float) -> void:
	rotate_x(delta * 0.5)
	rotate_y(delta * 0.25)
	rotate_z(delta)
