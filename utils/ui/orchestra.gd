extends Node2D
@onready var crystal_pickup_player: AudioStreamPlayer = $CrystalPickupPlayer

func queue_crystal_pickup_sound() -> void:
	crystal_pickup_player.play()
