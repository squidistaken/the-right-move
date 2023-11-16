extends CharacterBody2D

const speed = 400
const dash_multiplier = 5
@export var jump_velocity = -2000
@export var acc = 50
@export var fric = 70
@export var grav = 120
const cooldown = 0.5

var has_jumped = false
var has_dashed = false
var has_super_jumped = false

func _physics_process(_delta):
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(speed * input_dir, acc)
		if Input.is_action_just_pressed("dash") and not has_dashed:
			velocity.x *= dash_multiplier
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
	if Input.is_action_just_pressed("jump") and not has_jumped and is_on_floor:
		has_jumped = true
		velocity.y = jump_velocity
	elif Input.is_action_pressed("super_jump") and not has_super_jumped:
		while is_on_floor():
			if await charge_super_jump():
				velocity.y = jump_velocity
				has_super_jumped = true
				has_super_jumped = await refresh_cooldown()
				
		
	else:
		
		velocity.y += grav
		if is_on_floor():
			has_jumped = false

func refresh_cooldown(has_condition: bool = true) -> bool:
	await get_tree().create_timer(cooldown).timeout
	return false


# TODO: Debug Super Jump
func charge_super_jump() -> bool:
	while Input.is_action_pressed("super_jump"):
		await get_tree().create_timer(cooldown).timeout
		if Input.is_action_just_released("super_jump"):
			return true
	return false
