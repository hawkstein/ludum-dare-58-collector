extends Node2D

const FIREBALL = preload("uid://6a3l6orrerda")
const MANA = preload("uid://vrd8l0abflp6")

@onready var pause_window: Control = %PauseWindow
@onready var ui: CanvasLayer = $UI
@onready var hud: CanvasLayer = $HUD
@onready var tower: Tower = %Tower
@onready var enemies: Node2D = %Enemies
@onready var wave_spawner: Node2D = %WaveSpawner
@onready var collector: CharacterBody2D = $Collector
@onready var spells: Node2D = $Spells
@onready var mana: Node2D = $Mana
@onready var mana_count: Label = %ManaCount

var fire_mana: int = 0;

func _init() -> void:
	var frostbolt = UpgradePath.create_frostbolt()


func _ready() -> void:
	ui.hide()
	pause_window.hide()


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#ScreenChanger.change_to("main_menu")
	#
	#if Input.is_action_just_pressed("Pause"):
		#pause_window.show()s
		#get_tree().paused = true


func _on_tower_tower_destroyed() -> void:
	ui.show()
	hud.hide()
	for child in enemies.get_children():
		child.queue_free()
	for child in mana.get_children():
		child.queue_free()
	for child in spells.get_children():
		child.queue_free()
	get_tree().paused = true


func reset() -> void:
	ui.hide()
	hud.show()
	get_tree().paused = false
	tower.reset()
	wave_spawner.spawn_wave()
	collector.reset()
	
	fire_mana = 0
	_update_mana_count()


func _on_reset_button_pressed() -> void:
	reset()


func _on_tower_cast_spell(spell: String) -> void:
	print("casting ", spell, "...")
	var target = _pick_nearest_target()
	if target:
		_fire_at_moving_target(target)


func _fire_at_moving_target(target:Enemy) -> void:
	var spell_velocity = 200.0
	var cast_position = tower.get_cast_global_position()
	var expected_flight_time = (target.position - cast_position).length() / spell_velocity
	var predicted_position = target.predicted_global_position(expected_flight_time)
	var flight_time = (predicted_position - cast_position).length() / spell_velocity 
	var tween = create_tween()
	var fireball_spell = FIREBALL.instantiate()
	fireball_spell.global_position = cast_position
	spells.add_child(fireball_spell)
	tween.tween_property(fireball_spell, "global_position", predicted_position, flight_time)
	tween.tween_callback(_damage_target.bind(target))
	tween.tween_callback(fireball_spell.queue_free)


func _pick_nearest_target() -> Enemy:
	var potential_targets = enemies.get_children()
	if potential_targets.size() <= 0:
		return null
	var nearest_target:Enemy = null
	var nearest_distance_sq = INF
	for child in potential_targets:
		var distance_sq = child.global_position.distance_squared_to(tower.global_position)
		if distance_sq < nearest_distance_sq:
				nearest_distance_sq = distance_sq
				nearest_target = child
	return nearest_target


func _damage_target(target:Enemy) -> void:
	target.take_damage(50)
	if target.health <= 0:
		_spawn_mana(target.global_position)
		target.queue_free()


func _spawn_mana(mana_position:Vector2) -> void:
	var mana_amount := 3
	var angle_step = TAU / mana_amount
	for i in range(mana_amount):
		var angle = (angle_step * i) + randf_range(-0.3, 0.3)
		var radius = randf_range(20, 40)
		var offset = Vector2(cos(angle), sin(angle)) * radius
		var mana_drop:Mana = MANA.instantiate()
		mana_drop.global_position = mana_position
		var scatter_position = mana_position + offset
		var tween = create_tween()
		var duration = 1.0
		tween.tween_property(mana_drop, "global_position", scatter_position, duration)
		tween.set_ease(Tween.EASE_IN_OUT)
		mana_drop.modulate.a = 0.0
		var alpha_tween = create_tween()
		alpha_tween.tween_property(mana_drop, "modulate:a", 1.0, duration/2)
		alpha_tween.tween_callback(mana_drop.set.bind("is_collectible", true))
		mana.add_child(mana_drop)
		mana_drop.mana_collected.connect(_pickup_mana.bind(mana_drop))


func _pickup_mana(mana_drop:Mana) -> void:
	var cast_position = tower.get_cast_global_position()
	var tween = create_tween()
	var duration = (mana_drop.global_position - cast_position).length() / 400
	tween.tween_property(mana_drop, "global_position", cast_position, duration)
	tween.tween_callback(mana_drop.queue_free)
	
	fire_mana +=1
	_update_mana_count()


func _update_mana_count() -> void:
	mana_count.text = "Mana: {0} {1} {2} {3}".format([str(fire_mana) ,"x", "x", "x"])
