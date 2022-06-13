extends Spatial

onready var particles_fireball : Particles = $Particles_Fireball
onready var particles_sparks : Particles = $Particles_Sparks

func _on_Timer_Despawn_timeout():
	queue_free()

func _ready() -> void:
	particles_fireball.emitting = true
	particles_sparks.emitting = true
