extends CharacterBody2D

const MAX_SPEED := 300
const ACCELERATION := 10.0
const DECELERATION := 5.0

func _ready() -> void:
	reset()


func reset() -> void:
	position = get_viewport().get_mouse_position()


func _physics_process(delta: float) -> void:
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() > 20:
		direction = direction.normalized()
		velocity = lerp(velocity, direction * MAX_SPEED, delta * ACCELERATION)
	elif direction.length() > 0.2:
		direction = direction.normalized()
		velocity = lerp(velocity, direction * MAX_SPEED, delta * DECELERATION)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
