extends Node

var can_action = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_action == true:
		if Input.is_action_just_pressed("action"):
			queue_free()


func _on_destroyable_area_body_entered(body):
	can_action = true


func _on_destroyable_area_body_exited(body):
	can_action = false
