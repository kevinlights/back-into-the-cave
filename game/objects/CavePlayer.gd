extends KinematicBody2D

class_name CavePlayer

const _Dust : PackedScene = preload("res://objects/Dust.tscn")

const MOVE_SPEED : float = 40.0
const HILL_CLIMB_SPEED : float = 20.0
const JUMP_SPEED : float = 128.0
const FALL_INCR : float = 386.0
const MAX_FALL_SPEED : float = 160.0

onready var sprite : Sprite = $Sprite
onready var sprite_mirror_l : Sprite = $Sprite_MirrorL
onready var sprite_mirror_r : Sprite = $Sprite_MirrorR

var velocity : Vector2 = Vector2.ZERO

func do_the_dusty() -> void:
	for dir in [Vector2.LEFT, Vector2.RIGHT]:
		var dust : Sprite = _Dust.instance()
		get_parent().add_child(dust)
		dust.global_position = self.global_position + Vector2(0, 4) + (dir * 4.0)
		dust.velocity = dir * 16.0

func move(direction : Vector2, delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(MOVE_SPEED * direction * delta)
	if collision != null and collision.normal.snapped(Vector2(0.25, 0.25)).y == -0.75:
		position.y -= HILL_CLIMB_SPEED * delta
		move_and_collide(HILL_CLIMB_SPEED * direction * delta)
		velocity.y = 0.0

func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_up") and test_move(transform, Vector2.DOWN):
		velocity = Vector2(0, -JUMP_SPEED)
	if Input.is_action_pressed("ui_left"):
		move(Vector2.LEFT, delta)
		sprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		move(Vector2.RIGHT, delta)
		sprite.flip_h = false
	
	velocity.y += FALL_INCR * delta
	velocity.y = clamp(velocity.y, -JUMP_SPEED, MAX_FALL_SPEED)
	
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if collision.normal == Vector2.UP:
			if velocity.y > 96.0:
				do_the_dusty()
			velocity = Vector2.ZERO
		elif collision.normal == Vector2.DOWN:
			velocity = Vector2.ZERO
		elif collision.normal.snapped(Vector2(0.25, 0.25)).y == -0.75:
			velocity.y = 0.0
	
	sprite_mirror_l.flip_h = sprite.flip_h
	sprite_mirror_r.flip_h = sprite.flip_h
	
	if position.x > 256.0:
		position.x -= 256.0
	elif position.x < 0.0:
		position.x += 256.0
