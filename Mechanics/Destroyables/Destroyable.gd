extends Node

var can_destroy = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action"):
		if can_destroy == true:
			$Sprite.play("default",1,true)

func _on_interaction_body_entered(body):
	if body.name == "Player":
		can_destroy = true

func _on_interaction_body_exited(body):
	body = null
	can_destroy = false

func _on_sprite_animation_finished():
	# TODO: Save information state
	queue_free()
