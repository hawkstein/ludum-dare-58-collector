extends Node2D

const FIREBALL = preload("uid://6a3l6orrerda")
const FROSTBOLT = preload("uid://yslthdu0xon2")

const MANA = preload("uid://vrd8l0abflp6")

@onready var pause_window: Control = %PauseWindow
@onready var ui: MainUserInterface = $UI
@onready var hud: CanvasLayer = $HUD
@onready var tower: Tower = %Tower
@onready var enemies: Node2D = %Enemies
@onready var wave_spawner: Node2D = %WaveSpawner
@onready var collector: CharacterBody2D = $Collector
@onready var spells: Node2D = $Spells
@onready var mana: Node2D = $Mana
@onready var gauge: ManaGauge = %Gauge

@onready var progress:ProgressData = DataStore.get_model("Progress")

var fire_mana: int = 0
var water_mana: int = 0
var earth_mana: int = 0
var air_mana: int = 0
var max_drops: int = 5
var conversation_rate: int = 1

var fire_crystals: int = 0
var water_crystals: int = 0
var earth_crystals: int = 0
var air_crystals: int = 0


func _ready() -> void:
	ui.hide()
	pause_window.hide()
	_update_mana_count()
	_update_crystals_from_progress()
	_update_collector_ratio()
	var speed_idx = progress.collector_levels.speed - 1
	collector.speed = UpgradePath.collector.attributes.get("speed")[speed_idx].value


func _update_collector_ratio() -> void:
	var ratio_level = progress.collector_levels.ratio
	var ratio_upgrades = UpgradePath.collector.attributes.ratio
	var ratio:String = ratio_upgrades[ratio_level - 1].value
	var split = ratio.split("/")
	conversation_rate = int(split[0])
	max_drops = int(split[1])


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#ScreenChanger.change_to("main_menu")
	#
	#if Input.is_action_just_pressed("Pause"):
		#pause_window.show()s
		#get_tree().paused = true


func _on_tower_tower_destroyed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	ui.show()
	
	var loop_count = progress.loop_count + 1
	progress.update(loop_count, "loop_count")
	progress.update(fire_crystals, "fire_crystals")
	progress.update(water_crystals, "water_crystals")
	progress.update(earth_crystals, "earth_crystals")
	progress.update(air_crystals, "air_crystals")
	ui.show_loop(loop_count)
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
	wave_spawner.reset()
	wave_spawner.spawn_wave()
	
	var speed_idx = progress.collector_levels.speed - 1
	collector.speed = UpgradePath.collector.attributes.get("speed")[speed_idx].value
	
	_reset_drops()
	_update_mana_count()
	_update_crystals_from_progress()
	_update_collector_ratio()


func _on_reset_button_pressed() -> void:
	reset()


func _on_tower_cast_spell(spell: String) -> void:
	print("casting ", spell, "...")
	var target
	match spell:
		"fireball":
			target = _pick_nearest_target()
			if target:
				_fire_at_moving_target(target)
		"frostbolt":
			target = _pick_random_target()
			if target:
				_fire_frostbolt_at(target)
			pass
		"rockblast":
			target = _pick_random_target()
			pass
		"tornado":
			target = _pick_random_target()
			pass


func _fire_frostbolt_at(target:Enemy) -> void:
	var frostbolt_spell:Frostbolt = FROSTBOLT.instantiate()
	var cast_position = tower.get_cast_global_position()
	frostbolt_spell.global_position = cast_position
	spells.add_child(frostbolt_spell)
	frostbolt_spell.aim_at_target(target.global_position)
	frostbolt_spell.hit_enemy.connect(_frostbolt_damage, ConnectFlags.CONNECT_ONE_SHOT)


func _frostbolt_damage(enemy:Enemy) -> void:
	var frostbolt_damage:float = _get_spell_attribute("frostbolt", "damage")
	print("damage: ", frostbolt_damage)
	var frostbolt_slow:float = _get_spell_attribute("frostbolt", "slow")
	enemy.slow_time = frostbolt_slow
	_damage_target(enemy, frostbolt_damage)


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
	
	var fireball_damage:float = _get_spell_attribute("fireball", "damage")
	
	tween.tween_property(fireball_spell, "global_position", predicted_position, flight_time)
	tween.tween_callback(_damage_target.bind(target, fireball_damage))
	tween.tween_callback(fireball_spell.queue_free)


func _get_spell_attribute(spell:StringName, attribute:String) -> Variant:
	var level = progress.spells.get(spell)[attribute]
	var upgrades = UpgradePath.get(spell).attributes[attribute]
	return upgrades[level - 1].value


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


func _pick_random_target() -> Enemy:
	var potential_targets = enemies.get_children()
	if potential_targets.size() <= 0:
		return null
	return potential_targets.pick_random()

func _damage_target(target:Enemy, amount:float) -> void:
	target.take_damage(amount)
	if target.health <= 0:
		_spawn_mana(target.global_position)
		target.queue_free()


func _spawn_mana(mana_position:Vector2) -> void:
	var mana_amount := 5
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
	
	match mana_drop.mana_type:
		Mana.Type.FIRE:
			fire_mana += 1
		Mana.Type.WATER:
			water_mana += 1
		Mana.Type.EARTH:
			earth_mana += 1
		Mana.Type.AIR:
			air_mana += 1
	
	_check_drops()
	_update_mana_count()

func _check_drops() -> void:
	var total := fire_mana + water_mana + earth_mana + air_mana
	if total > max_drops:
		var drops = {
			Mana.Type.FIRE: fire_mana,
			Mana.Type.WATER: water_mana,
			Mana.Type.EARTH: earth_mana,
			Mana.Type.AIR: air_mana
		}
		var largest_amounts:Array[Mana.Type] = []
		var biggest_value = 0

		for mana_type in drops:
			if drops[mana_type] > biggest_value:
				biggest_value = drops[mana_type]
		
		for mana_type in drops:
			if drops[mana_type] == biggest_value:
				largest_amounts.append(mana_type)
		
		_get_crystal(largest_amounts)
		_reset_drops()


func _get_crystal(mana_types:Array[Mana.Type]) -> void:
	var chosen = mana_types.pick_random()
	Orchestra.queue_crystal_pickup_sound()
	match chosen:
		Mana.Type.FIRE:
			fire_crystals += conversation_rate
		Mana.Type.WATER:
			water_crystals += conversation_rate
		Mana.Type.EARTH:
			earth_crystals += conversation_rate
		Mana.Type.AIR:
			air_crystals += conversation_rate
	gauge.update_crystals(fire_crystals, water_crystals, earth_crystals, air_crystals)

func _reset_drops() -> void:
	fire_mana = 0
	water_mana = 0
	earth_mana = 0
	air_mana = 0


func _update_mana_count() -> void:
	gauge.update_gauge(fire_mana, water_mana, earth_mana, air_mana, max_drops)


func _update_crystals_from_progress() -> void:
	fire_crystals = progress.fire_crystals
	water_crystals = progress.water_crystals
	earth_crystals = progress.earth_crystals
	air_crystals = progress.air_crystals
	gauge.update_crystals(fire_crystals, water_crystals, earth_crystals, air_crystals)


func _on_upgrade_button_pressed() -> void:
	ui.show_upgrade()
