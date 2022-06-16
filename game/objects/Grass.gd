extends Area2D

onready var sprite : Sprite = $Sprite
onready var timer_next_frame : Timer = $Timer_NextFrame

func _on_Grass_body_entered(body) -> void:
	if body is CavePlayer and sprite.frame == 0:
		sprite.frame = 1
		timer_next_frame.start()

func _on_Timer_NextFrame_timeout() -> void:
	if sprite.frame == 3:
		sprite.frame = 0
	else:
		sprite.frame += 1
		timer_next_frame.start()
