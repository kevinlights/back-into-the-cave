extends Area2D

signal player_reached

func _on_Door_body_entered(body) -> void:
	if body is CavePlayer:
		emit_signal("player_reached")
