class_name Rockblast
extends Area2D

var speed:float = 80.0
var velocity:Vector2 = Vector2.ZERO
var target_position:Vector2

signal hit_enemies(enemies_hit:Array[Enemy])

func _ready():
	get_tree().create_timer(10.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	var distance = target_position - global_position
	if distance.length() > velocity.length() * delta:
		position += velocity * delta
	else:
		position = target_position
		monitoring = true
		await get_tree().physics_frame
		var hit_areas = get_overlapping_areas()
		var enemies_hit:Array[Enemy] = []
		for area in hit_areas:
			if area.is_in_group("enemies") and area is Enemy:
				enemies_hit.append(area)
		hit_enemies.emit(enemies_hit, global_position)
		queue_free()


func aim_at_target(p_position: Vector2):
	target_position = p_position
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
