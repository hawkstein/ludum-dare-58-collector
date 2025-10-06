extends Node2D

const ENEMY = preload("uid://dl3c43g803ldy")

@onready var spawn_path: Path2D = %SpawnPath
@onready var spawn_length = spawn_path.curve.get_baked_length()
@onready var enemies: Node2D = %Enemies
@onready var tower: Node2D = %Tower
@onready var spawn_timer: Timer = $SpawnTimer
@onready var waves_label: Label = %WavesLabel

var enemy_spawns:int
var wave:int

var max_waves: int = 18

func _ready() -> void:
	reset()
	spawn_wave()


func reset() -> void:
	enemy_spawns = 3
	wave = 0


func spawn_wave() -> void:
	wave += 1
	waves_label.text = "Wave {0} of {1}".format([wave, max_waves])
	var wave_health = 70.0 + (wave * wave * 5.0)
	#print("wave health ", wave_health)
	for i in range(enemy_spawns):
		spawn_enemy(ENEMY, get_random_position(), wave_health)
	enemy_spawns += 2
	spawn_timer.start()


func spawn_enemy(enemy_scene: PackedScene, pos: Vector2, health:float) -> void:
	var instance = enemy_scene.instantiate()
	instance.position = pos;
	tower.connect_to_enemy(instance)
	enemies.add_child(instance)
	instance.max_health = health
	instance.health = health


func get_random_position() -> Vector2:
	return spawn_path.curve.sample_baked(randf() * spawn_length)


func _on_spawn_timer_timeout() -> void:
	spawn_wave()
