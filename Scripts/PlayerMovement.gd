extends CharacterBody2D

const speed = 400
const dash_multiplier = 1250
const jump_velocity = -2000
const acc = 50
const fric = 70
const grav = 120
const cooldown = 0.5

var has_jumped = false
var has_dashed = false
var can_super_jump = false

func _physics_process(_delta):
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(speed * input_dir, acc)
		if Input.is_action_pressed("super_jump"):
			velocity.x /= 2
		if Input.is_action_just_pressed("dash") and not has_dashed:
			velocity.x += Input.get_axis("move_left","move_right") * dash_multiplier
			has_dashed = true
			has_dashed = await refresh_cooldown()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, fric)
		
	if has_dashed: 
		velocity.y = 0
	else: 
		jump()
	
	move_and_slide()

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir = input_dir.normalized()
	return input_dir

func jump():
	if Input.is_action_just_pressed("jump") and not has_jumped:
		has_jumped = true
		velocity.y = jump_velocity
	elif velocity.y != 0:
		has_jumped = true
		velocity.y += grav
	else:
		velocity.y += grav
		if is_on_floor():
			has_jumped = false
	
	charge_super_jump()
	if can_super_jump and Input.is_action_just_released("super_jump"):
		has_jumped = true
		can_super_jump = false
		velocity.y = jump_velocity * 1.5

func refresh_cooldown() -> bool:
	await get_tree().create_timer(cooldown).timeout
	return false

func charge_super_jump():
	var charge_time = 0.7
	if Input.is_action_just_pressed("super_jump"):
		has_jumped = true
		$PlayerSuperJumpTimer.start(charge_time)
	if Input.is_action_just_released("super_jump"):
		$PlayerSuperJumpTimer.stop()

func _on_player_super_jump_timer_timeout():
	can_super_jump = true
