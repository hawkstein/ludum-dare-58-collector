class_name Tower
extends Area2D

signal tower_destroyed
signal cast_spell(spell:String)

@onready var health_bar: Node2D = $HealthBar
@onready var spell_timers: Node2D = $SpellTimers
@onready var cast_node: Node2D = $CastNode

var progress: ProgressData = DataStore.get_model("Progress")
var max_health: float = 1000.0
var current_health: float = 1000.0

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
	for key in progress.spells.keys():
		var spell = progress.spells[key]
		if not spell.unlocked:
			continue
		var rates = UpgradePath.get(key).attributes.rate
		var rate_idx = spell.rate - 1
		var spell_timer = Timer.new()
		spell_timer.autostart = true
		spell_timer.wait_time = rates[rate_idx].value
		spell_timers.add_child(spell_timer)
		spell_timer.timeout.connect(cast_spell.emit.bind(key))


func _on_enemy_attacked_tower(attack_strength:float) -> void:
	current_health -= attack_strength
	if current_health <= 0:
		teardown()
		tower_destroyed.emit()
	health_bar.current_health = (current_health/max_health) * 100

func get_cast_global_position() -> Vector2:
	return cast_node.global_position
