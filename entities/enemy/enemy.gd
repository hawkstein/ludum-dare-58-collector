class_name Enemy
extends Node2D

signal attacked_tower(attack_strength:float)

@onready var attack_timer:Timer = $AttackTimer
var tower_position: Vector2 = Vector2(472, 281) # Hardcoded tower position
var speed: float = 30.0
var target_distance:float = 30.0
var is_moving: bool = true
var is_attacking: bool = false


func _process(delta) -> void:
	if not is_moving:
		return
	
	var direction = (tower_position - global_position).normalized()
	var distance_to_tower = global_position.distance_to(tower_position)
	
	if distance_to_tower < target_distance:
		is_moving = false
		is_attacking = true
		attack_timer.timeout.connect(_on_attack_timeout)
		attack_timer.start()
	else:
		global_position += direction * speed * delta


func _on_attack_timeout() -> void:
	attacked_tower.emit(100)


func predicted_global_position(time:float) -> Vector2:
	if not is_moving:
		return global_position
	var direction = (tower_position - global_position).normalized()
	var velocity = direction * speed * time
	return global_position + velocity
