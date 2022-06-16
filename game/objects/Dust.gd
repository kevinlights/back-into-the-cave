extends Sprite

var velocity : Vector2

func _on_Timer_NextFrame_timeout() -> void:
	if frame == 4:
		queue_free()
	else:
		frame += 1

func _physics_process(delta : float) -> void:
	position += velocity * delta
