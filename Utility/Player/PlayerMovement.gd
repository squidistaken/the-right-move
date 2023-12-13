extends CharacterBody2D

const speed = 1000
const dash_multiplier = 1500
const jump_velocity = -3000
const acc = 50
const fric = 70
const grav = 120

var has_jumped: bool = false
var is_jumping: bool = false
var has_actioned: bool = false
var has_dashed: bool = false
var can_super_jump: bool = false
var is_charging_super_jump: bool = false

var reset_position: Vector2

func _physics_process(_delta):
	animate()
	var input_dir: Vector2 = input()
	
	if Input.is_action_just_pressed("action") and not has_actioned:
		has_actioned = true
		has_actioned = await refresh_cooldown(1)
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(speed * input_dir, acc)
		if Input.is_action_pressed("super_jump"):
			velocity.x /= 2
		if Input.is_action_just_pressed("dash") and not has_dashed:
			velocity.x += Input.get_axis("move_left","move_right") * dash_multiplier
			has_dashed = true
			is_jumping = false
			has_dashed = await refresh_cooldown(0.5)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, fric)
	
	if has_dashed: 
		velocity.y = 0
	elif has_actioned:
		velocity.x = 0
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
		is_jumping = true
		velocity.y = jump_velocity
	elif velocity.y != 0:
		has_jumped = true
		velocity.y += grav
	else:
		is_jumping = false
		velocity.y += grav
		if is_on_floor():
			has_jumped = false
			charge_super_jump()
	if can_super_jump and Input.is_action_just_released("super_jump"):
		has_jumped = true
		is_jumping = true
		can_super_jump = false
		velocity.y = jump_velocity * 1.5

func refresh_cooldown(cooldown) -> bool:
	await get_tree().create_timer(cooldown).timeout
	return false

func charge_super_jump():
	var charge_time = 0.5
	if Input.is_action_just_pressed("super_jump"):
		$SuperJumpTimer.start(charge_time)
		is_charging_super_jump = true
	if Input.is_action_just_released("super_jump"):
		is_charging_super_jump = false
		$SuperJumpTimer.stop()
		

func _on_player_super_jump_timer_timeout():
	can_super_jump = true

func on_enter():
	reset_position = position


# Animation Handler
func animate():
	if is_on_floor():
		if Input.is_action_pressed("action"):
			$Sprite.play("action")
		elif Input.is_action_just_pressed("dash") and not has_dashed:
			$Animator.play("dash")
			$Sprite.play("dash")
		elif Input.is_action_pressed("super_jump"):
			if is_charging_super_jump:
				$Sprite.play("super_jump_charge")
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			$Animator.play("walk")
			$Sprite.play("walk")
		 
		else:
			$Animator.stop()
			$Sprite.play("idle")
	else:
		if Input.is_action_pressed("action"):
			$Sprite.play("action")
		elif Input.is_action_just_pressed("dash") and not has_dashed:
			$Animator.play("dash")
			$Sprite.play("dash")
		else:
			$Sprite.play("jump")
			if is_jumping:
				$Animator.play("jump")
				
	
func _on_player_sprite_animation_finished():
	match $Sprite.animation:
		"super_jump_charge":
			$Sprite.frame = 1
		"dash":
			$Sprite.stop()

