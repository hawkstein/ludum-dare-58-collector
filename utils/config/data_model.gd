class_name DataModel
extends Resource

signal property_updated(property_name)

func to_dict() -> Dictionary:
	var props = get_property_list()
	var dict: Dictionary = { }
	
	for p in props:
		if p.usage == PROPERTY_USAGE_SCRIPT_VARIABLE and not p.name == "property_updated":
			dict[p.name] = get(p.name)
	
	return dict

func from_dict(dict: Dictionary):
	var props = get_property_list()
	
	for p in props:
		if dict.has(p.name):
			if p.type == Variant.Type.TYPE_ARRAY:
				var typed_array:Array[String] = []
				typed_array.assign(dict[p.name])
				set(p.name, typed_array)
			elif p.type == Variant.Type.TYPE_INT:
				set(p.name, int(dict[p.name]))
			elif p.type == Variant.Type.TYPE_DICTIONARY:
				self[p.name].assign(dict[p.name])
			else:
				set(p.name, dict[p.name])


func update(value:Variant, property_name:StringName) -> void:
	#print("DataModel: Update {0} to {1}".format([property_name, value]))
	set(property_name, value)
	property_updated.emit(property_name)

func update_by(value:Variant, property_name:StringName) -> void:
	#print("DataModel: Update {0} by {1}".format([property_name, value]))
	set(property_name, get(property_name) + value)
	property_updated.emit(property_name)


class PropertyMeta:
	var label:String
	func _init(p_label:String):
		label = p_label

class SliderMeta extends PropertyMeta:
	var min_value:float
	var max_value:float
	var step:float
	func _init(p_label:String, p_min = 0.0, p_max = 1.0, p_step = 0.05):
		super._init(p_label)
		min_value = p_min
		max_value = p_max
		step = p_step
		
