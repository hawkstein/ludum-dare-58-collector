class_name Mana
extends Node2D

signal mana_collected

@onready var area_2d: Area2D = $Area2D
var is_collected:bool = false
var is_collectible:bool = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if is_collected or not is_collectible:
		return
	area_2d.set_deferred("monitoring", false)
	is_collected = true
	mana_collected.emit()
