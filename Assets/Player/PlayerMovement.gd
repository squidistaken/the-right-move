extends CharacterBody2D

const speed = 1000
const dash_multiplier = 1500
const jump_velocity = -3000
const acc = 50
const fric = 70
const grav = 120
const cooldown = 0.5

var has_jumped = false
var has_dashed = false
var can_super_jump = false
#var has_super_jumped = false
var is_charging_super_jump = false

var reset_position: Vector2

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
		set_rotation(0)
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
		if velocity.y < 0:
			rotate(PI/12)
		else:
			if rotation != 0:
				rotate(PI/12)
				
	else:
		velocity.y += grav
		if is_on_floor():
			has_jumped = false
			# has_super_jumped = false
			set_rotation(0)
			charge_super_jump()
	if can_super_jump and Input.is_action_just_released("super_jump"):
		has_jumped = true
		# has_super_jumped = true
		can_super_jump = false
		velocity.y = jump_velocity * 1.5

func refresh_cooldown() -> bool:
	await get_tree().create_timer(cooldown).timeout
	return false

func charge_super_jump():
	var charge_time = 0.5
	if Input.is_action_just_pressed("super_jump"):
		$PlayerSuperJumpTimer.start(charge_time)
		is_charging_super_jump = true
	if Input.is_action_just_released("super_jump"):
		is_charging_super_jump = false
		$PlayerSuperJumpTimer.stop()
		

func _on_player_super_jump_timer_timeout():
	can_super_jump = true

func on_enter():
	reset_position = position

# Animation handler
func _process(_delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if velocity.y == 0 and not has_dashed:
			$PlayerSprite.play("walk")
		else:
			$PlayerSprite.play("idle")
			$PlayerSprite.stop()
	else:
		if is_charging_super_jump:
			$PlayerSprite.play("super_jump_charge")
		#elif has_jumped and has_super_jumped:
			#$PlayerSprite.play("super_jump")
		else:
			$PlayerSprite.play("idle")

func _on_player_sprite_animation_finished():
	match $PlayerSprite.animation:
		"super_jump_charge":
			$PlayerSprite.frame = 1
		
		#"super_jump":
			#$PlayerSprite.frame = 2
			#has_super_jumped = false
			
		
