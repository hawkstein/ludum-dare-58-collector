class_name ProgressData
extends DataModel

var fire_crystals := 0
var water_crystals := 0
var earth_crystals := 0
var air_crystals := 0

var spent_fire_crystals := 0
var spent_water_crystals := 0
var spent_earth_crystals := 0
var spent_air_crystals := 0

var loop_count := 0
var max_wave : = 1

var spells := {
	"fireball": {
		"unlocked": true,
		"damage": 1,
		"rate": 1,
		"burn": 1,
	},
	"frostbolt": {
		"unlocked": false,
		"damage": 0,
		"rate": 0,
		"slow": 0,
	},
	"rockblast": {
		"unlocked": false,
		"damage": 0,
		"rate": 0,
		"area": 0,
	},
	"tornado": {
		"unlocked": false,
		"damage": 0,
		"rate": 0,
		"duration": 0,
	}
}

var collector_levels: Dictionary[StringName, int] = {
	"speed": 1,
	"ratio": 1,
	"fire_filter": 0,
	"water_filter": 0,
	"earth_filter": 0,
	"air_filter": 0,
}

var tower_levels: Dictionary[StringName, int] = {
	"hp": 1,
	"drops": 1,
}

func from_dict(dict: Dictionary):
	super.from_dict(dict)
	for key in spells.keys():
		var spell:Dictionary = spells[key]
		for attr_key in spell.keys():
			if attr_key != "unlocked":
				spells[key][attr_key] = int(spells[key][attr_key])
	
	for key in collector_levels.keys():
		collector_levels[key] = int(collector_levels[key])
	
	for key in tower_levels.keys():
		tower_levels[key] = int(tower_levels[key])
