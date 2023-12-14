extends StaticBody2D

var push: float = -10
@export var type: String = ""
var is_colliding: bool = false
var player: CharacterBody2D

func _process(_delta):
	if is_colliding:
		player.move_local_x(push)

func _ready():
	match type:
		"individual": $Sprite.play("individual")
		"left": $Sprite.play("left")
		"middle": $Sprite.play("middle")
		"right": $Sprite.play("right")

func _on_interaction_body_entered(body):
	if body.name == "Player":
		player = body
		is_colliding = true
		
func _on_interaction_body_exited(_body):
	is_colliding = false
