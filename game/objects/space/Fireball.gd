extends Area

const ROTATE_SPEED : float = 1.0

onready var mesh : MeshInstance = $Mesh
onready var tween : Tween = $Tween

func set_fire_amount(amount : float) -> void:
	mesh.get_surface_material(0).set_shader_param("amount", amount)
	mesh.get_surface_material(1).emission_energy = amount * 2.0

func ignite() -> void:
	set_fire_amount(0.0)
	tween.interpolate_method(self, "set_fire_amount", 0.0, 1.0, 0.5)
	tween.start()

func disappear() -> void:
	set_fire_amount(1.0)
	tween.interpolate_method(self, "set_fire_amount", 1.0, 0.0, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()

func _on_Fireball_body_entered(body) -> void:
	if body is OrbShip:
		body.get_hit()

func _physics_process(delta : float) -> void:
	global_transform = global_transform.rotated(global_transform.basis.y.normalized(), ROTATE_SPEED * delta)

func _ready() -> void:
	ignite()
