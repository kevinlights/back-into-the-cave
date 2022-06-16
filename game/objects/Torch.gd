extends Sprite

func _on_Timer_NextFame_timeout() -> void:
	frame = wrapi(frame + 1, 0, 4)

func _ready() -> void:
	frame = randi() % 4
