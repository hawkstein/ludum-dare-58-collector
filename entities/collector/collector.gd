extends CharacterBody2D

const MAX_SPEED := 300
const ACCELERATION := 10.0

func _ready() -> void:
	reset()


func reset() -> void:
	position = get_viewport().get_mouse_position()


func _physics_process(delta: float) -> void:
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() < 3:
		velocity = Vector2.ZERO
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		direction = direction.normalized()
		velocity =  lerp(velocity, direction * MAX_SPEED, delta * ACCELERATION)
		
	move_and_slide()
