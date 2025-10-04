class_name Enemy
extends Node2D

signal attacked_tower(attack_strength:float)

@onready var attack_timer:Timer = $AttackTimer
var tower_positiom: Vector2 = Vector2(472, 281) # Hardcoded tower position
var speed: float = 30.0
var target_distance:float = 30.0
var is_moving: bool = true
var is_attacking: bool = false


func _process(delta) -> void:
	if not is_moving:
		return
	
	var direction = (tower_positiom - global_position).normalized()
	var distance_to_tower = global_position.distance_to(tower_positiom)
	
	if distance_to_tower < target_distance:
		is_moving = false
		is_attacking = true
		attack_timer.timeout.connect(_on_attack_timeout)
		attack_timer.start()
	else:
		global_position += direction * speed * delta


func _on_attack_timeout() -> void:
	attacked_tower.emit(100)
