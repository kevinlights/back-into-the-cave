extends KinematicBody2D

const MOVE_SPEED : float = 40.0
const JUMP_SPEED : float = 128.0
const FALL_INCR : float = 386.0
const MAX_FALL_SPEED : float = 160.0

onready var sprite : Sprite = $Sprite
onready var sprite_mirror_l : Sprite = $Sprite_MirrorL
onready var sprite_mirror_r : Sprite = $Sprite_MirrorR

var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_up") and test_move(transform, Vector2.DOWN):
		velocity = Vector2(0, -JUMP_SPEED)
	if Input.is_action_pressed("ui_left"):
		move_and_collide(MOVE_SPEED * Vector2.LEFT * delta)
		sprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		move_and_collide(MOVE_SPEED * Vector2.RIGHT * delta)
		sprite.flip_h = false
	
	velocity.y += FALL_INCR * delta
	velocity.y = clamp(velocity.y, -JUMP_SPEED, MAX_FALL_SPEED)
	
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if collision.normal == Vector2.UP:
			velocity = Vector2.ZERO
		elif collision.normal == Vector2.DOWN:
			velocity = Vector2.ZERO
	
	sprite_mirror_l.flip_h = sprite.flip_h
	sprite_mirror_r.flip_h = sprite.flip_h
	
	if position.x > 256.0:
		position.x -= 256.0
	elif position.x < 0.0:
		position.x += 256.0
