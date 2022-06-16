extends Area

onready var mesh : MeshInstance = $Mesh
onready var tween : Tween = $Tween

func set_fire_amount(amount : float) -> void:
	mesh.get_surface_material(0).set_shader_param("amount", amount)

func ignite() -> void:
	set_fire_amount(0.0)
	tween.interpolate_method(self, "set_fire_amount", 0.0, 1.0, 1.0)
	tween.start()

func extinguish() -> void:
	set_fire_amount(1.0)
	tween.interpolate_method(self, "set_fire_amount", 1.0, 0.0, 1.0)
	tween.start()

func _on_FireRing_body_entered(body) -> void:
	if body is OrbShip:
		body.get_hit()
