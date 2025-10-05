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

var progress: ProgressData = DataStore.get_model("Progress")

func _ready() -> void:
	_on_tab_bar_tab_changed(0)


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
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	if progress.spells[spell].unlocked:
		_create_unlocked_spell_tab(spell_entry)
	else:
		_create_locked_spell_tab(spell_entry)


func _create_unlocked_spell_tab(spell_entry:SpellEntry) -> void:
	var attr_keys = spell_entry.attributes.keys()
	for key in attr_keys:
		var h_box:HBoxContainer = HBoxContainer.new()
		var l:Label = Label.new()
		l.text = key
		h_box.add_child(l)
		var upgrade_button:Button = Button.new()
		var attr_level = progress.spells.fireball[key]
		var next_level = attr_level + 1
		var has_next_level = spell_entry.attributes[key].size() >= next_level
		if has_next_level:
			upgrade_button.text = "Buy Level {0}".format([next_level])
			upgrade_button.pressed.connect(_purchase_upgrade.bind("fireball", key, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
		else:
			upgrade_button.text = "Complete"
			upgrade_button.disabled = true
		h_box.add_child(upgrade_button)
		if has_next_level:
			var cost: Label = Label.new()
			var attribute = spell_entry.attributes[key]
			cost.text = "{0} {1} {2} {3}".format(attribute[0].cost)
			h_box.add_child(cost)
		spell_v_box.add_child(h_box)


func _purchase_upgrade(spell:StringName, attribute:String, level:int, upgrade_button) -> void:
	print("purchase level {0} {1} for {2}".format([str(level), attribute, spell]))
	progress.spells[spell][attribute] = level
	progress.update(progress.spells, "spells")
	print(progress.spells[spell][attribute])
	var attr_level = progress.spells.fireball[attribute]
	var spell_entry: SpellEntry = UpgradePath.get(spell)
	var next_level = attr_level + 1
	var has_next_level = spell_entry.attributes[attribute].size() >= next_level
	if has_next_level:
		upgrade_button.text = "Buy Level {0}".format([next_level])
		upgrade_button.pressed.connect(_purchase_upgrade.bind("fireball", attribute, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
	else:
		upgrade_button.text = "Complete"
		upgrade_button.disabled = true


func _create_locked_spell_tab(spell_entry:SpellEntry) -> void:
	var h_box:HBoxContainer = HBoxContainer.new()
	var unlock_button:Button = Button.new()
	unlock_button.text = "Unlock {0}".format([spell_entry.spell_name])
	h_box.add_child(unlock_button)
	spell_v_box.add_child(h_box)
