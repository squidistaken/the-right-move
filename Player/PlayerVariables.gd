extends Node

const speed: int = 1000
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
