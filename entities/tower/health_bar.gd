extends Node2D

@export var max_health: float = 100.0
@export var current_health: float = 100.0:
	set(health):
		current_health = clampf(health, 0.0, max_health)
		_update_health_bar()

@onready var bar_color_rect: ColorRect = %BarColorRect

func _ready():
	_update_health_bar()

func _update_health_bar():
	var health_scale = current_health / max_health
	bar_color_rect.scale.x = health_scale
	if health_scale > 0.5:
		bar_color_rect.modulate = Color.GREEN
	elif health_scale > 0.25:
		bar_color_rect.modulate = Color.YELLOW
	else:
		bar_color_rect.modulate = Color.RED
