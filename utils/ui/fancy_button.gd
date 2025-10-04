extends Button


@onready var over_stream_player: AudioStreamPlayer = $OverStreamPlayer
@onready var pressed_stream_player: AudioStreamPlayer = $PressedStreamPlayer


func _on_mouse_entered() -> void:
	if not over_stream_player.playing:
		over_stream_player.play()


func _on_pressed() -> void:
	if not pressed_stream_player.playing:
		pressed_stream_player.play()
