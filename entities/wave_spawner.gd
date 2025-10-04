extends Node2D

const ENEMY = preload("uid://dl3c43g803ldy")

@onready var spawn_path: Path2D = %SpawnPath
@onready var spawn_length = spawn_path.curve.get_baked_length()
@onready var enemies: Node2D = %Enemies
@onready var tower: Node2D = %Tower
@onready var spawn_timer: Timer = $SpawnTimer

var enemy_spawns := 5

func _ready() -> void:
	spawn_wave()


func spawn_wave() -> void:
	for i in range(enemy_spawns):
		spawn_enemy(ENEMY, get_random_position())
	spawn_timer.start()


func spawn_enemy(enemy_scene: PackedScene, pos: Vector2) -> void:
	var instance = enemy_scene.instantiate()
	instance.position = pos;
	tower.connect_to_enemy(instance)
	enemies.add_child(instance)


func get_random_position() -> Vector2:
	return spawn_path.curve.sample_baked(randf() * spawn_length)


func _on_spawn_timer_timeout() -> void:
	spawn_wave()
