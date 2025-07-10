extends CharacterBody2D

# Hitrosti in časi
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 600
const ROLL_DURATION = 0.3
const DASH_SPEED = 700
const DASH_DURATION = 0.2

# Animacija, spawn točka in bullet scena
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Stanja
var is_rolling = false
var roll_timer = 0.0
var is_dashing = false
var dash_timer = 0.0
var can_dash = true
var dash_vector = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	# Gravitacija
	if not is_on_floor():
		if not is_dashing:
			velocity += get_gravity() * delta
	else:
		can_dash = true

	# Skok
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_rolling:
		velocity.y = JUMP_VELOCITY

	# Premikanje
	var direction := Input.get_axis("move_left", "move_right")

	# Roll
	if Input.is_action_just_pressed("roll") and is_on_floor() and direction != 0:
		is_rolling = true
		roll_timer = ROLL_DURATION
		velocity.x = direction * ROLL_SPEED
		animated_sprite_2d.play("roll")

	# Dash
	if Input.is_action_just_pressed("dash") and not is_on_floor() and can_dash:
		is_dashing = true
		dash_timer = DASH_DURATION
		can_dash = false

		var input_direction = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)

		dash_vector = input_direction.normalized()
		if dash_vector == Vector2.ZERO:
			dash_vector = Vector2(1, 0) if not animated_sprite_2d.flip_h else Vector2(-1, 0)

	# Uporaba roll/dash/move
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false

	elif is_dashing:
		dash_timer -= delta
		velocity = dash_vector * DASH_SPEED
		if dash_timer <= 0:
			is_dashing = false

	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animacije
	if is_rolling:
		animated_sprite_2d.play("roll")
	elif is_dashing:
		animated_sprite_2d.play("dash")
	elif is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

	# Smer pogleda
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	move_and_slide()
