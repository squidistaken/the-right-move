extends StaticBody2D

@export var push: float = 5.0
@export var type: String = ""
var is_colliding: bool = false
var player

func _process(delta):
	if is_colliding:
		player.velocity.x -= 20

func _ready():
	match type:
		"left": $Sprite.play("left")
		"middle": $Sprite.play("middle")
		"right": $Sprite.play("right")

func _on_interaction_body_entered(body):
	if body.name == "Player":
		player = body
		is_colliding = true
		
func _on_interaction_body_exited(body):
	is_colliding = false