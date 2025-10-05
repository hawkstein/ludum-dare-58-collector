class_name Tower
extends Area2D

signal tower_destroyed
signal cast_spell(spell:String)

var max_health: float = 100.0
var current_health: float = 1000.0

@onready var health_bar: Node2D = $HealthBar
@onready var spell_timers: Node2D = $SpellTimers
@onready var cast_node: Node2D = $CastNode

@onready var progress: ProgressData = DataStore.get_model("Progress")

var fireball_upgrades = UpgradePath.create_fireball()

func _ready() -> void:
	reset()


func connect_to_enemy(enemy:Enemy) -> void:
	enemy.attacked_tower.connect(_on_enemy_attacked_tower)


func teardown() -> void:
	for child in spell_timers.get_children():
		child.queue_free()


func reset() -> void:
	current_health = max_health
	health_bar.current_health = 100
	_build_timers()


func _build_timers() -> void:
	var fireball_rates = fireball_upgrades.attributes.rate
	var rate_level = progress.spells.fireball.rate
	var fireball_timer = Timer.new()
	fireball_timer.autostart = true
	fireball_timer.wait_time = fireball_rates[rate_level - 1].value
	spell_timers.add_child(fireball_timer)
	fireball_timer.timeout.connect(cast_spell.emit.bind("fireball"))


func _on_enemy_attacked_tower(attack_strength:float) -> void:
	current_health -= attack_strength
	if current_health <= 0:
		teardown()
		tower_destroyed.emit()
	health_bar.current_health = (current_health/max_health) * 100

func get_cast_global_position() -> Vector2:
	return cast_node.global_position
