class_name InputData
extends DataModel

var up_events:Array[String] = ["W", "UP"]
var down_events:Array[String] = ["S", "DOWN"]
var left_events:Array[String] = ["A", "LEFT"]
var right_events:Array[String] = ["D", "RIGHT"]
var pause_events:Array[String] = ["P"]

func _init() -> void:
	InputMap.add_action("Up")
	InputMap.add_action("Down")
	InputMap.add_action("Left")
	InputMap.add_action("Right")
	InputMap.add_action("Pause")
	
	set_meta("title", "Input")
	set_meta("up_events", PropertyMeta.new("Up"))
	set_meta("down_events", PropertyMeta.new("Down"))
	set_meta("left_events", PropertyMeta.new("Left"))
	set_meta("right_events", PropertyMeta.new("Right"))
	set_meta("pause_events", PropertyMeta.new("Pause"))

func from_dict(dict:Dictionary) -> void:
	super.from_dict(dict)
	var prop_list = get_property_list()
	for prop in prop_list:
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			var events = get(prop.name) as Array[String]
			var meta = get_meta(prop.name) as PropertyMeta
			_map_strings_to_events(meta.label, events)

func update(value:Variant, property_name:StringName) -> void:
	var meta = get_meta(property_name) as PropertyMeta
	var events = get(property_name) as Array[String]
	var idx = events.find(value.previous_keycode)
	events.set(idx, value.keycode_as_string)
	InputMap.action_erase_events(meta.label)
	_map_strings_to_events(meta.label, events)
	super.update(events, property_name)


func _map_strings_to_events(action:StringName, events:Array[String]) -> void:
	for event_code in events:
		var input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(event_code)
		InputMap.action_add_event(action, input_event)
