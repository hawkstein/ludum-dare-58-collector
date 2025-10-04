class_name Tower
extends Area2D

signal tower_destroyed

var max_health: float = 1000.0
var current_health: float = 1000.0

@onready var health_bar: Node2D = $HealthBar

func connect_to_enemy(enemy:Enemy) -> void:
	enemy.attacked_tower.connect(_on_enemy_attacked_tower)


func reset() -> void:
	current_health = max_health
	health_bar.current_health = 100


func _on_enemy_attacked_tower(attack_strength:float) -> void:
	current_health -= attack_strength
	if current_health <= 0:
		tower_destroyed.emit()
	health_bar.current_health = (current_health/max_health) * 100
