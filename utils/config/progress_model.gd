class_name ProgressData
extends DataModel

var fire_crystals := 0
var water_crystals := 0
var earth_crystals := 0
var air_crystals := 0

var loop_count := 0

var spells := {
	"fireball": {
		"damage": 1,
		"range": 1,
		"rate": 1,
		"burn": 1,
	},
	"frostbolt": {
		"speed": 0,
		"range": 0,
		"rate": 0,
		"slow": 0,
	},
	"rock": {
		"speed": 0,
		"range": 0,
		"rate": 0,
		"area": 0,
	},
	"tornado": {
		"speed": 0,
		"range": 0,
		"rate": 0,
		"duration": 0,
	}
}

var collector_levels: Dictionary[StringName, int]= {
	"speed": 0,
	"radius": 0,
	"duration": 0,
	"rate": 0
}

func from_dict(dict: Dictionary):
	super.from_dict(dict)
	for key in spells.keys():
		var spell:Dictionary = spells[key]
		for attr_key in spell.keys():
			spells[key][attr_key] = int(spells[key][attr_key])
