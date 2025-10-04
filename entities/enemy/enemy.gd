extends Node2D

var tower_positiom: Vector2 = Vector2(472, 281) # Hardcoded tower position
var speed: float = 30.0
var target_distance:float = 50.0
var is_moving: bool = true
var is_attacking: bool = false

func _process(delta):
	if not is_moving:
		return
	
	var direction = (tower_positiom - global_position).normalized()
	var distance_to_tower = global_position.distance_to(tower_positiom)
	
	if distance_to_tower < target_distance:
		is_moving = false
		is_attacking = true
	else:
		global_position += direction * speed * delta
