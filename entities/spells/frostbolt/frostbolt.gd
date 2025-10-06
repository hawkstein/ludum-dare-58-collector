class_name Frostbolt
extends Area2D

var speed:float = 150.0
var velocity:Vector2 = Vector2.ZERO

signal hit_enemy(enemy:Enemy)

func _ready():
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += velocity * delta


func aim_at_target(target_position: Vector2):
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	rotation = velocity.angle()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area is Enemy:
		hit_enemy.emit(area)
		queue_free()
