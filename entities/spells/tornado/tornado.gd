class_name Tornado
extends Area2D

var speed:float = 200.0
var velocity:Vector2 = Vector2.ZERO

signal hit_enemy(enemy:Enemy)

func _physics_process(delta: float) -> void:
	position += velocity * delta


func aim_at_target(target_position: Vector2, duration:float):
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	get_tree().create_timer(duration).timeout.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area is Enemy:
		hit_enemy.emit(area)
