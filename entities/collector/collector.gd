extends CharacterBody2D

const ACCELERATION := 10.0

var speed: float = 300.0

func _physics_process(delta: float) -> void:
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() < 3:
		velocity = Vector2.ZERO
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		direction = direction.normalized()
		velocity =  lerp(velocity, direction * speed, delta * ACCELERATION)
		
	move_and_slide()
