class_name GameplayData
extends DataModel

var show_instructions := true

func _init() -> void:
	set_meta("title", "Gameplay")
	set_meta("show_instructions", PropertyMeta.new("Instructions"))
