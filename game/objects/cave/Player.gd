extends KinematicBody2D

class_name CavePlayer

const _Dust : PackedScene = preload("res://objects/cave/Dust.tscn")
const _Poof : PackedScene = preload("res://objects/cave/Poof.tscn")

const MOVE_SPEED : float = 44.0
const HILL_CLIMB_SPEED : float = 20.0
const JUMP_SPEED : float = 128.0
const FALL_INCR : float = 386.0
const MAX_FALL_SPEED : float = 160.0
const COYOTE_ALLOWANCE : float = 0.18
const CAVE_WIDTH : float = 320.0
const ANIM_SPEED : float = 10.0

onready var sprite : Sprite = $Sprite
onready var sprite_mirror_l : Sprite = $Sprite_MirrorL
onready var sprite_mirror_r : Sprite = $Sprite_MirrorR

var velocity : Vector2 = Vector2.ZERO
var anim_index : float = 0.0
var coyote_timer : float = 0.0

signal dead

func do_the_dusty() -> void:
	for dir in [Vector2.LEFT, Vector2.RIGHT]:
		var dust : Sprite = _Dust.instance()
		get_parent().add_child(dust)
		dust.global_position = self.global_position + Vector2(0, 3) + (dir * 4.0)
		dust.velocity = dir * 16.0

func poof() -> void:
	for dir in range(0.0, 360.0, 45.0):
		var poof : Sprite = _Poof.instance()
		get_parent().add_child(poof)
		poof.global_position = self.global_position
		poof.velocity = Vector2.RIGHT.rotated(deg2rad(dir)) * 32.0

func move(direction : Vector2, delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(MOVE_SPEED * direction * delta)
	if collision != null and collision.normal.snapped(Vector2(0.25, 0.25)).y == -0.75:
		position.y -= HILL_CLIMB_SPEED * delta
		move_and_collide(HILL_CLIMB_SPEED * direction * delta)
		velocity.y = 0.0

func _on_Area_DeadlyFinder_body_entered(body) -> void:
	poof()
	SoundController.play_sound("miss")
	emit_signal("dead")
	queue_free()

func _physics_process(delta : float) -> void:
	var running : bool = false
	if Input.is_action_pressed("left"):
		move(Vector2.LEFT, delta)
		sprite.flip_h = true
		running = true
	if Input.is_action_pressed("right"):
		move(Vector2.RIGHT, delta)
		sprite.flip_h = false
		running = true
	
	velocity.y += FALL_INCR * delta
	velocity.y = clamp(velocity.y, -JUMP_SPEED, MAX_FALL_SPEED)
	
	anim_index += ANIM_SPEED * delta
	sprite.frame = 0 if not running else wrapi(anim_index, 1, 5)
	if not test_move(transform, Vector2.DOWN):
		sprite.frame = 5
	else:
		coyote_timer = 0.0
	
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if collision.normal == Vector2.UP:
			if velocity.y > 96.0:
				SoundController.play_sound("land")
				do_the_dusty()
			velocity = Vector2.ZERO
			coyote_timer = 0.0
		elif collision.normal == Vector2.DOWN:
			velocity = Vector2.ZERO
		elif collision.normal.snapped(Vector2(0.25, 0.25)).y in [0.75, -0.75]:
			velocity.y = 0.0
			coyote_timer = 0.0
	
	coyote_timer += delta
	var can_jump : bool = test_move(transform, Vector2.DOWN) or (coyote_timer < COYOTE_ALLOWANCE)
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity = Vector2(0, -JUMP_SPEED)
		sprite.frame = 5
		position.y -= 1.0
		SoundController.play_sound("jump")
	
	sprite_mirror_l.flip_h = sprite.flip_h
	sprite_mirror_r.flip_h = sprite.flip_h
	sprite_mirror_l.frame = sprite.frame
	sprite_mirror_r.frame = sprite.frame
	
	if position.x > CAVE_WIDTH:
		position.x -= CAVE_WIDTH
	elif position.x < 0.0:
		position.x += CAVE_WIDTH
