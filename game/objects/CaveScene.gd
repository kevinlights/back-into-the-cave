extends Node2D

const WORLD_SIZE : Vector2 = Vector2(256, 128)

onready var player : KinematicBody2D = $Player

var player_pos : Vector2 = Vector2.ZERO

func _physics_process(delta : float) -> void:
	player_pos = (player.position / WORLD_SIZE)
