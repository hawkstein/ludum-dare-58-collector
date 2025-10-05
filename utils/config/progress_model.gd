class_name ProgressData
extends DataModel

var fire_crystals := 0
var water_crystals := 0
var earth_crystals := 0
var air_crystals := 0

var loop_count := 0

#var spells := {
	#"fireball": {
		#"speed": 10.0,
		#"range": 200.0,
		#"rate": 3.0,
		#"burn": 5.0,
	#},
	#"frostbolt": {
		#"speed": 10.0,
		#"range": 200.0,
		#"rate": 3.0,
		#"slow": 5.0,
	#},
	#"rock": {
		#"speed": 10.0,
		#"range": 200.0,
		#"rate": 3.0,
		#"area": 5.0,
	#},
	#"cyclone": {
		#"speed": 10.0,
		#"range": 200.0,
		#"rate": 3.0,
		#"duration": 5.0,
	#}
#}

var collector := {
	"speed": 10.0,
	"radius": 10.0,
	"duration": 1.0,
	"rate": 3.0
}

func _init() -> void:
	pass
