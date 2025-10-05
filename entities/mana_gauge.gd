class_name ManaGauge
extends Control

@onready var fire_rect: ColorRect = %FireRect
@onready var water_rect: ColorRect = %WaterRect
@onready var earth_rect: ColorRect = %EarthRect
@onready var air_rect: ColorRect = %AirRect

@onready var fire_label: Label = %FireLabel
@onready var water_label: Label = %WaterLabel
@onready var earth_label: Label = %EarthLabel
@onready var air_label: Label = %AirLabel

var bar_size = 148 # pixels for the parent control node

func update_gauge(fire:int, water:int, earth:int, air:int, max_drops:int) -> void:
	fire_rect.custom_minimum_size = Vector2((float(fire) / max_drops) * bar_size, 0)
	water_rect.custom_minimum_size = Vector2((float(water) / max_drops) * bar_size, 0)
	earth_rect.custom_minimum_size = Vector2((float(earth) / max_drops) * bar_size, 0)
	air_rect.custom_minimum_size = Vector2((float(air) / max_drops) * bar_size, 0)


func update_crystals(fire:int, water:int, earth:int, air:int) -> void:
	fire_label.text = str(fire)
	water_label.text = str(water)
	earth_label.text = str(earth)
	air_label.text = str(air)
