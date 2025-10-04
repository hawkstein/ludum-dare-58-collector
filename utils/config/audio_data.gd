class_name AudioData
extends DataModel

var master_volume := 0.8:
	set(volume):
		master_volume = volume
		AudioManager.set_master_volume(volume)

var sfx_volume := 1.0:
	set(volume):
		sfx_volume = volume
		AudioManager.set_sfx_volume(volume)

var music_volume := 1.0:
	set(volume):
		music_volume = volume
		AudioManager.set_music_volume(volume)

func _init() -> void:
	set_meta("title", "Audio")
	set_meta("master_volume", SliderMeta.new("Master"))
	set_meta("sfx_volume", SliderMeta.new("SFX"))
	set_meta("music_volume", SliderMeta.new("Music"))
