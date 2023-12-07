extends StaticBody2D

@export var push: float = 5.0
@export var type: String = ""
var is_colliding: bool = false
var player

func _process(_delta):
	if is_colliding:
		player.velocity.x -= 20

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
