extends Area2D

const _Twinkle : PackedScene = preload("res://objects/Twinkle.tscn")

onready var sprite : Sprite = $Sprite
onready var timer_next_frame : Timer = $Timer_NextFrame

signal collected

func _on_Coin_body_entered(body) -> void:
	if body is CavePlayer:
		for dir in range(0.0, 360.0, 45.0):
			var twinkle : Sprite = _Twinkle.instance()
			get_parent().add_child(twinkle)
			twinkle.global_position = self.global_position + Vector2(4, 4)
			twinkle.velocity = Vector2.RIGHT.rotated(deg2rad(dir)) * 32.0
		emit_signal("collected")
		queue_free()

func _on_Timer_NextFrame_timeout() -> void:
	sprite.frame = wrapi(sprite.frame + 1, 0, 6)
