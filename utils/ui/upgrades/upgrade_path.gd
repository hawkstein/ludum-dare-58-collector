extends Node

# Cost: [fire/water/earth/air] crystals.

var fireball:SpellEntry = create_fireball()
var frostbolt:SpellEntry = create_frostbolt()
var rockblast:SpellEntry = create_rockblast()
var tornado:SpellEntry = create_tornado()
var collector:SpellEntry = create_collector()

func create_fireball() -> SpellEntry:
	var fireball_entry = SpellEntry.new("Fireball")
	fireball_entry.is_unlocked = true
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [1,0,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	fireball_entry.add_attribute("rate", rate_values)
	
	var damage_values:Array[Dictionary] = [
		{ "value": 40.0, "cost" : [0,0,0,0], },
		{ "value": 50.0, "cost" : [1,0,1,0], },
		{ "value": 60.0, "cost" : [2,0,2,0], },
		{ "value": 100.0, "cost" : [4,0,4,0], },
	]
	fireball_entry.add_attribute("damage", damage_values)
	
	var burn_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	fireball_entry.add_attribute("burn", burn_values)
	
	return fireball_entry

func create_frostbolt() -> SpellEntry:
	var frostbolt_entry = SpellEntry.new("Frostbolt")
	frostbolt_entry.unlock_cost = Array([0,2,0,0], TYPE_INT, "", null)
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [0,1,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	frostbolt_entry.add_attribute("rate", rate_values)
	
	var damage_values:Array[Dictionary] = [
		{ "value": 20.0, "cost" : [0,0,0,0], },
		{ "value": 25.0, "cost" : [1,0,1,0], },
		{ "value": 40.0, "cost" : [2,0,2,0], },
		{ "value": 60.0, "cost" : [4,0,4,0], },
	]
	frostbolt_entry.add_attribute("damage", damage_values)
	
	var slow_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	frostbolt_entry.add_attribute("slow", slow_values)
	
	return frostbolt_entry


func create_rockblast() -> SpellEntry:
	var rockblast_entry = SpellEntry.new("Rockblast")
	rockblast_entry.unlock_cost = Array([0,0,2,0], TYPE_INT, "", null)
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [1,0,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	rockblast_entry.add_attribute("rate", rate_values)
	
	var damage_values:Array[Dictionary] = [
		{ "value": 20.0, "cost" : [0,0,0,0], },
		{ "value": 25.0, "cost" : [1,0,1,0], },
		{ "value": 40.0, "cost" : [2,0,2,0], },
		{ "value": 60.0, "cost" : [4,0,4,0], },
	]
	rockblast_entry.add_attribute("damage", damage_values)
	
	var area_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	rockblast_entry.add_attribute("area", area_values)
	
	return rockblast_entry


func create_tornado() -> SpellEntry:
	var tornado_entry = SpellEntry.new("Tornado")
	tornado_entry.unlock_cost = Array([0,0,0,2], TYPE_INT, "", null)
	
	var rate_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 2.5, "cost" : [1,0,0,0], },
		{ "value": 2.0, "cost" : [2,0,0,1], },
		{ "value": 1.0, "cost" : [4,0,0,2], },
	]
	tornado_entry.add_attribute("rate", rate_values)
	
	var damage_values:Array[Dictionary] = [
		{ "value": 20.0, "cost" : [0,0,0,0], },
		{ "value": 25.0, "cost" : [1,0,1,0], },
		{ "value": 40.0, "cost" : [2,0,2,0], },
		{ "value": 60.0, "cost" : [4,0,4,0], },
	]
	tornado_entry.add_attribute("damage", damage_values)
	
	var burn_values:Array[Dictionary] = [
		{ "value": 3.0, "cost" : [0,0,0,0], },
		{ "value": 6.0, "cost" : [2,0,1,0], },
		{ "value": 12.0, "cost" : [4,0,2,0], },
		{ "value": 24.0, "cost" : [6,0,3,0], },
	]
	tornado_entry.add_attribute("burn", burn_values)
	
	return tornado_entry


func create_collector() -> SpellEntry:
	var collector_entry = SpellEntry.new("Collector")
	
	var size_values:Array[Dictionary] = [
		{ "value": "S", "cost": [0,0,0,0] },
		{ "value": "M", "cost": [2,0,0,0] },
		{ "value": "L", "cost": [3,0,0,0] },
		{ "value": "XL", "cost": [4,0,0,0] },
	]
	collector_entry.add_attribute("size", size_values)
	
	var ratio_values:Array[Dictionary] = [
		{ "value": "1/5", "cost": [0,0,0,0] },
		{ "value": "3/10", "cost": [2,2,2,2] },
		{ "value": "10/20", "cost": [6,6,6,6] },
		{ "value": "20/30", "cost": [20,20,20,20] },
	]
	collector_entry.add_attribute("ratio", ratio_values)
	
	var speed_values:Array[Dictionary] = [
		{ "value": 20, "cost": [0,0,0,0] },
		{ "value": 30, "cost": [2,2,2,2] },
		{ "value": 40, "cost": [6,6,6,6] },
		{ "value": 60, "cost": [20,20,20,20] },
	]
	collector_entry.add_attribute("speed", speed_values)
	
	return collector_entry
