extends Node2D

const LEVELS : Array = [
	preload("res://levels/cave/Level1.tscn"),
	preload("res://levels/cave/Level2.tscn"),
	preload("res://levels/cave/Level3.tscn")
]

const WORLD_SIZE : Vector2 = Vector2(320, 180)

onready var blackout : Polygon2D = $Blackout
onready var tween : Tween = $Tween

var level : Node2D

var current_level : int = 0
var stop_on_level : int = 3
var coins_collected : int = 0
var player_pos : Vector2

signal last_level_in_batch_finished

func get_player_pos() -> Vector2:
	return level.player.position / WORLD_SIZE

func fade_out() -> void:
	tween.interpolate_property(blackout, "modulate", null, Color.white, 0.5)
	tween.start()

func fade_in() -> void:
	tween.interpolate_property(blackout, "modulate", null, Color.transparent, 0.5)
	tween.start()

func spawn_level() -> void:
	if is_instance_valid(level):
		level.queue_free()
	level = LEVELS[current_level].instance()
	call_deferred("add_child", level)
	level.connect("player_dead", self, "on_player_dead")
	level.connect("exit_reached", self, "on_level_completed")

func next_level() -> void:
	current_level += 1
	if current_level >= stop_on_level:
		emit_signal("last_level_in_batch_finished")
	else:
		spawn_level()

func on_level_completed() -> void:
	fade_out()
	yield(tween, "tween_all_completed")
	coins_collected += level.coins_collected
	next_level()
	fade_in()

func on_player_dead() -> void:
	fade_out()
	yield(tween, "tween_all_completed")
	spawn_level()
	fade_in()

func _physics_process(delta : float) -> void:
	if is_instance_valid(level):
		if is_instance_valid(level.player):
			player_pos = get_player_pos()
