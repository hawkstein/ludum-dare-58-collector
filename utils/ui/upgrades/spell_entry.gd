class_name SpellEntry
extends RefCounted

var spell_name:String
var is_unlocked:bool = false
var attributes:Dictionary = {}

func _init(p_name:String) -> void:
	spell_name = p_name

## Expects a values array to be passed which contains all the upgrades
## attributes. Must have a Dictionary with value & cost keys. The cost
## property must be 4 length array, for fire/water/earth/air crystals.
func add_attribute(attr_name:StringName, values:Array[Dictionary]) -> void:
	for value in values:
		assert(value.has("value"))
		assert(value.has("cost"))
		var cost = value.get("cost")
		assert(cost is Array)
		assert(cost.size() == 4, "cost array must only have 4 values")
	attributes.set(attr_name, values)
