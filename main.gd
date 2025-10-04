extends Node2D
@onready var pause_window: Control = %PauseWindow

func _ready() -> void:
	pause_window.hide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		ScreenChanger.change_to("main_menu")
	
	if Input.is_action_just_pressed("Pause"):
		pause_window.show()
		get_tree().paused = true
