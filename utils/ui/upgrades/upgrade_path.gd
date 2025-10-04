class_name UpgradePath
extends Resource

static func create_fireball() -> SpellEntry:
	var fireball = SpellEntry.new("Fireball")
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [1,0,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	fireball.add_attribute("rate", rate_values)
	
	var burn_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	fireball.add_attribute("burn", burn_values)
	
	return fireball

static func create_frostbolt() -> SpellEntry:
	var frostbolt = SpellEntry.new("Frostbolt")
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [0,1,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	frostbolt.add_attribute("rate", rate_values)
	
	var slow_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	frostbolt.add_attribute("slow", slow_values)
	
	return frostbolt
