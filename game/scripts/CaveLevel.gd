extends Node2D

onready var player : KinematicBody2D = $Player

var coins_collected : int = 0

signal player_dead
signal exit_reached

func _on_Player_dead() -> void:
	emit_signal("player_dead")

func _on_Door_player_reached() -> void:
	emit_signal("exit_reached")

func _on_coin_collected() -> void:
	coins_collected += 1
