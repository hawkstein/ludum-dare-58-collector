extends Control

@onready var grimoire_v_box: VBoxContainer = %GrimoireVBox
@onready var collector_v_box: VBoxContainer = %CollectorVBox
@onready var tower_v_box: VBoxContainer = %TowerVBox
@onready var spell_v_box: VBoxContainer = %SpellVBox
@onready var upgrade_tabs:Array[VBoxContainer] = [
	grimoire_v_box,
	collector_v_box,
	tower_v_box,
]
@onready var crystals_label: Label = %CrystalsLabel


var progress: ProgressData = DataStore.get_model("Progress")

func _ready() -> void:
	_on_tab_bar_tab_changed(0)
	_on_spells_tab_bar_tab_changed(0)
	_create_collector_tab()
	_create_tower_tab()


func _on_tab_bar_tab_changed(tab: int) -> void:
	for idx in range(upgrade_tabs.size()):
		if tab == idx:
			upgrade_tabs[idx].show()
		else:
			upgrade_tabs[idx].hide()


func _on_spells_tab_bar_tab_changed(tab: int) -> void:
	_clear_spell_tab()
	match tab:
		0:
			_create_spell_tab("fireball")
		1:
			_create_spell_tab("frostbolt")
		2:
			_create_spell_tab("rockblast")
		3:
			_create_spell_tab("tornado")


func _clear_spell_tab() -> void:
	var children = spell_v_box.get_children()
	for child in children:
		child.queue_free()


func _create_spell_tab(spell:StringName) -> void:
	if progress.spells[spell].unlocked:
		_create_unlocked_spell_tab(spell)
	else:
		_create_locked_spell_tab(spell)


func _create_unlocked_spell_tab(spell:StringName) -> void:
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var attr_keys = spell_entry.attributes.keys()
	for key in attr_keys:
		var h_box:HBoxContainer = HBoxContainer.new()
		var l:Label = Label.new()
		l.text = key
		h_box.add_child(l)
		var upgrade_button:Button = Button.new()
		h_box.add_child(upgrade_button)
		var cost_label: Label = Label.new()
		upgrade_button.pressed.connect(_purchase_spell_upgrade.bind(spell, key, upgrade_button, cost_label))
		h_box.add_child(cost_label)
		_update_button_and_label(spell, key, upgrade_button, cost_label)
		spell_v_box.add_child(h_box)


func _update_button_and_label(spell:StringName, key:String, upgrade_button:Button, cost_label:Label) -> void:
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var attr_level = progress.spells.get(spell)[key]
	var next_level = attr_level + 1
	var has_next_level = spell_entry.attributes[key].size() >= next_level
	
	if has_next_level:
		upgrade_button.text = "Buy Level {0}".format([next_level])
	else:
		upgrade_button.text = "Complete"
		upgrade_button.disabled = true
		
	if has_next_level:
		var attribute = spell_entry.attributes[key]
		cost_label.text = "{0} {1} {2} {3}".format(attribute[next_level - 1].cost)
	else:
		cost_label.text = ""


func _purchase_spell_upgrade(spell:StringName, attribute:String, upgrade_button:Button, cost_label:Label) -> void:
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var next_idx = progress.spells.get(spell)[attribute]
	var cost = spell_entry.attributes.get(attribute)[next_idx].cost
	var can_afford = _check_cost(cost)
	if can_afford:
		_pay_cost(cost)
		var next_level = next_idx + 1
		print("purchase level {0} {1} for {2}".format([str(next_level), attribute, spell]))
		progress.spells[spell][attribute] = next_level
		progress.update(progress.spells, "spells")
		_update_button_and_label(spell, attribute, upgrade_button, cost_label)


func _check_cost(cost:Array) -> bool:
	assert(cost.size() == 4)
	return (progress.fire_crystals >= cost[0] and 
			progress.water_crystals >= cost[1] and 
			progress.earth_crystals >= cost[2] and 
			progress.air_crystals >= cost[3])


func _pay_cost(cost:Array) -> void:
	assert(cost.size() == 4)
	progress.update_by(-cost[0], "fire_crystals")
	progress.update_by(cost[0], "spent_fire_crystals")
	
	progress.update_by(-cost[1], "water_crystals")
	progress.update_by(cost[1], "spent_water_crystals")
	
	progress.update_by(-cost[2], "earth_crystals")
	progress.update_by(cost[2], "spent_earth_crystals")
	
	progress.update_by(-cost[3], "air_crystals")
	progress.update_by(cost[3], "spent_air_crystals")
	
	update_crystals_label()


func update_crystals_label() -> void:
	crystals_label.text = "F:{0} - W:{1} - E:{2} - A:{3}".format([
		progress.fire_crystals,
		progress.water_crystals,
		progress.earth_crystals,
		progress.air_crystals
	])


func _create_locked_spell_tab(spell:StringName) -> void:
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var h_box:HBoxContainer = HBoxContainer.new()
	var unlock_button:Button = Button.new()
	unlock_button.text = "Unlock {0}".format([spell_entry.spell_name])
	unlock_button.pressed.connect(_on_unlock_spell_pressed.bind(spell))
	h_box.add_child(unlock_button)
	var cost_label: Label = Label.new()
	cost_label.text = "Cost: {0} {1} {2} {3}".format(spell_entry.unlock_cost)
	h_box.add_child(cost_label)
	spell_v_box.add_child(h_box)


func _on_unlock_spell_pressed(spell:StringName) -> void:
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var can_afford = _check_cost(spell_entry.unlock_cost)
	if can_afford:
		_pay_cost(spell_entry.unlock_cost)
		progress.spells.get(spell).unlocked = true
		progress.update(progress.spells, "spells")
		_clear_spell_tab()
		_create_spell_tab(spell)



func _create_collector_tab() -> void:
	var collector_entry = UpgradePath.collector
	var attr_keys = collector_entry.attributes.keys()
	for key in attr_keys:
		var h_box:HBoxContainer = HBoxContainer.new()
		var l:Label = Label.new()
		l.text = key
		h_box.add_child(l)
		var upgrade_button:Button = Button.new()
		var attr_level = progress.collector_levels[key]
		var next_level = attr_level + 1
		var has_next_level = collector_entry.attributes[key].size() >= next_level
		if has_next_level:
			upgrade_button.text = "Buy Level {0}".format([next_level])
			upgrade_button.pressed.connect(_purchase_collector_upgrade.bind(key, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
		else:
			upgrade_button.text = "Complete"
			upgrade_button.disabled = true
		h_box.add_child(upgrade_button)
		if has_next_level:
			var cost: Label = Label.new()
			var attribute = collector_entry.attributes[key]
			cost.text = "Cost: {0} {1} {2} {3}".format(attribute[0].cost)
			h_box.add_child(cost)
		collector_v_box.add_child(h_box)


func _purchase_collector_upgrade(attribute:String, level:int, upgrade_button) -> void:
	print("purchase level {0} {1} for collector".format([str(level), attribute]))
	progress.collector_levels[attribute] = level
	progress.update(progress.collector_levels, "collector_levels")
	var attr_level = progress.collector_levels[attribute]
	var spell_entry: SpellEntry = UpgradePath.collector
	var next_level = attr_level + 1
	var has_next_level = spell_entry.attributes[attribute].size() >= next_level
	if has_next_level:
		upgrade_button.text = "Buy Level {0}".format([next_level])
		upgrade_button.pressed.connect(_purchase_collector_upgrade.bind(attribute, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
	else:
		upgrade_button.text = "Complete"
		upgrade_button.disabled = true


func _create_tower_tab() -> void:
	pass
