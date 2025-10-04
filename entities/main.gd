extends Node2D

@onready var pause_window: Control = %PauseWindow
@onready var ui: CanvasLayer = $UI
@onready var tower: Tower = %Tower
@onready var enemies: Node2D = %Enemies
@onready var wave_spawner: Node2D = %WaveSpawner
@onready var collector: CharacterBody2D = $Collector

func _ready() -> void:
	ui.hide()
	pause_window.hide()


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#ScreenChanger.change_to("main_menu")
	#
	#if Input.is_action_just_pressed("Pause"):
		#pause_window.show()
		#get_tree().paused = true


func _on_tower_tower_destroyed() -> void:
	ui.show()
	for child in enemies.get_children():
		child.queue_free()
	get_tree().paused = true


func reset() -> void:
	ui.hide()
	get_tree().paused = false
	tower.reset()
	wave_spawner.spawn_wave()
	collector.reset()


func _on_reset_button_pressed() -> void:
	reset()
