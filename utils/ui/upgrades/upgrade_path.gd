extends Node

var fireball:SpellEntry = create_fireball()
var frostbolt:SpellEntry = create_frostbolt()
var rockblast:SpellEntry = create_rockblast()
var tornado:SpellEntry = create_tornado()
var collector:SpellEntry = create_collector()

# Cost: [fire/water/earth/air] crystals.
# If Fire is North, Water is South, Earth is East and Air is West
# Then rate is always paired with 90 degrees CW
# and damage is always paired with 90 degrees CCW
# so fire rate costs fire & air crystals
# and water rate costs water & earth crystals

func create_fireball() -> SpellEntry:
	var fireball_entry = SpellEntry.new("Fireball")
	fireball_entry.is_unlocked = true
	
	# Cost: [fire/water/earth/air] crystals.
	var rate_values = _create_values(2.5, 4, [2,0,0,1], 0.7)
	fireball_entry.add_attribute("rate", rate_values)
	var damage_values = _create_values(50, 4, [2,0,1,0], 2)
	fireball_entry.add_attribute("damage", damage_values)
	var burn_values = _create_values(3.0, 4, [2,0,0,0], 4)
	fireball_entry.add_attribute("burn", burn_values)
	#fireball_entry.print_attributes()
	
	return fireball_entry

## scaling: "linear", "exponential", "quadratic"
func _create_values(base_value: float, size: int, base_cost: Array[int], growth_factor: float) -> Array[Dictionary]:
	var values: Array[Dictionary] = []
	values.append({"value": base_value, "cost": [0, 0, 0, 0]})
	
	for i in range(1, size):
		var value_multiplier = _calculate_multiplier(i, growth_factor, "exponential")
		var cost_multiplier = _calculate_multiplier(i, growth_factor, "quadratic")
		
		values.append({
			"value": base_value * value_multiplier, 
			"cost": base_cost.map(func(x): return ceili(x * cost_multiplier))
		})
	
	return values

func _calculate_multiplier(tier: int, growth_factor: float, scaling: String) -> float:
	match scaling:
		"exponential":
			return pow(growth_factor, tier)
		"quadratic":
			return tier * tier
		_: # linear
			return tier + 1


func create_frostbolt() -> SpellEntry:
	var frostbolt_entry = SpellEntry.new("Frostbolt")
	frostbolt_entry.unlock_cost = Array([0,2,0,0], TYPE_INT, "", null)
	
	# Cost: [fire/water/earth/air] crystals.
	frostbolt_entry.add_attribute("rate", _create_values(6.0, 4, [0,2,1,0], 0.8))
	frostbolt_entry.add_attribute("damage", _create_values(10.0, 4, [0,2,0,1], 2))
	frostbolt_entry.add_attribute("slow", _create_values(2.0, 4, [0,2,0,0], 1.5))
	#frostbolt_entry.print_attributes()
	
	return frostbolt_entry


func create_rockblast() -> SpellEntry:
	var rockblast_entry = SpellEntry.new("Rockblast")
	rockblast_entry.unlock_cost = Array([0,0,2,0], TYPE_INT, "", null)
	
	rockblast_entry.add_attribute("rate", _create_values(10.0, 4, [1,0,2,0], 0.75))
	rockblast_entry.add_attribute("damage", _create_values(10.0, 4, [0,1,2,0], 2))
	rockblast_entry.add_attribute("area", _create_values(20, 4, [0,0,2,0], 1.5))
	#rockblast_entry.print_attributes()
	
	return rockblast_entry


func create_tornado() -> SpellEntry:
	var tornado_entry = SpellEntry.new("Tornado")
	tornado_entry.unlock_cost = Array([0,0,0,2], TYPE_INT, "", null)
	
	tornado_entry.add_attribute("rate", _create_values(10.0, 4, [0,1,0,2], 0.75))
	tornado_entry.add_attribute("damage", _create_values(10.0, 4, [1,0,0,2], 2))
	tornado_entry.add_attribute("duration", _create_values(4, 4, [0,0,0,2], 3))
	#tornado_entry.print_attributes()
	
	return tornado_entry


func create_collector() -> SpellEntry:
	var collector_entry = SpellEntry.new("Collector")
	
	var ratio_values:Array[Dictionary] = [
		{ "value": "1/5", "cost": [0,0,0,0] },
		{ "value": "3/10", "cost": [2,0,2,0] },
		{ "value": "10/20", "cost": [0,4,0,4] },
		{ "value": "20/30", "cost": [4,4,4,4] },
	]
	collector_entry.add_attribute("ratio", ratio_values)
	
	var speed_values:Array[Dictionary] = [
		{ "value": 70.0, "cost": [0,0,0,0] },
		{ "value": 160.0, "cost": [1,1,1,1] },
		{ "value": 280.0, "cost": [2,2,2,2] },
		{ "value": 400.0, "cost": [3,3,3,3] },
		{ "value": 500.0, "cost": [4,4,4,4] },
	]
	collector_entry.add_attribute("speed", speed_values)
	
	var fire_filters:Array[Dictionary] = _create_filters([0,1,0,0])
	collector_entry.add_attribute("fire_filter", fire_filters)
	
	var water_filters:Array[Dictionary] = _create_filters([1,0,0,0])
	collector_entry.add_attribute("water_filter", water_filters)
	
	var earth_filters:Array[Dictionary] = _create_filters([0,0,0,1])
	collector_entry.add_attribute("earth_filter", earth_filters)
	
	var air_filters:Array[Dictionary] = _create_filters([0,0,1,0])
	collector_entry.add_attribute("air_filter", air_filters)
	
	return collector_entry


func _create_filters(cost:Array[int]) -> Array[Dictionary]:
	var filters:Array[Dictionary] = []
	for i in range(1, 5):
		filters.append( { "value": 20 * i, "cost":  cost.map(func(x): return x * i * 2) } )
	return filters
