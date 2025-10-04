extends CharacterBody2D

const MAX_SPEED := 300
const ACCELERATION := 5.0
const DECELERATION := 5.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")	
	velocity = lerp(velocity, direction * MAX_SPEED, delta * ACCELERATION) 
	
	move_and_slide()
