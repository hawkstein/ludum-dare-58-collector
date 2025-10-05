class_name Mana
extends Node2D

enum Type { FIRE, WATER, EARTH, AIR }

const FIRE_MANA = preload("uid://bwuqr77tjk0x1")
const WATER_MANA = preload("uid://cktgrbu0r6ydd")
const EARTH_MANA = preload("uid://doq30oumtqswj")
const AIR_MANA = preload("uid://cocvmk5qpp36i")

static var texture_map:Dictionary[Type,Resource] = {
	Type.FIRE: FIRE_MANA,
	Type.WATER: WATER_MANA,
	Type.EARTH: EARTH_MANA,
	Type.AIR: AIR_MANA,
}

var opposites = {
	Type.FIRE: Type.WATER,
	Type.WATER: Type.FIRE,
	Type.EARTH: Type.AIR,
	Type.AIR: Type.EARTH
}

# TODO: finish updating
var complements = {
	Type.FIRE: Type.AIR,
	Type.WATER: Type.FIRE,
	Type.EARTH: Type.AIR,
	Type.AIR: Type.EARTH
}

# TODO: finish updating
var antagonists = {
	Type.FIRE: Type.EARTH,
	Type.WATER: Type.FIRE,
	Type.EARTH: Type.AIR,
	Type.AIR: Type.EARTH
}

signal mana_collected

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_collected:bool = false
var is_collectible:bool = false
var mana_type:Type

func _ready() -> void:
	mana_type = Type.values()[randi() % Type.size()]
	sprite_2d.texture = texture_map[mana_type]

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if is_collected or not is_collectible:
		return
	area_2d.set_deferred("monitoring", false)
	is_collected = true
	mana_collected.emit()


static func type_to_string(type_to_convert:Type) -> String:
	match type_to_convert:
		Type.FIRE:
			return "Fire"
		Type.WATER:
			return "Water"
		Type.EARTH:
			return "Earth"
		Type.AIR:
			return "Air"
		_:
			return ""
