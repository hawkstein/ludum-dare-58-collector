extends Control

@onready var grimoire_v_box: VBoxContainer = %GrimoireVBox
@onready var collector_v_box: VBoxContainer = %CollectorVBox
@onready var tower_v_box: VBoxContainer = %TowerVBox
@onready var spell_v_box: VBoxContainer = %SpellVBox

@onready var progress: ProgressData = DataStore.get_model("Progress")

var fireball:SpellEntry = UpgradePath.create_fireball()

func _ready() -> void:
	grimoire_v_box.show()
	collector_v_box.hide()
	tower_v_box.hide()

func _on_tab_bar_tab_changed(tab: int) -> void:
	match tab:
		0:
			grimoire_v_box.show()
			collector_v_box.hide()
			tower_v_box.hide()
		1:
			collector_v_box.show()
			grimoire_v_box.hide()
			tower_v_box.hide()
		2:
			tower_v_box.show()
			grimoire_v_box.hide()
			collector_v_box.hide()


func _on_spells_tab_bar_tab_changed(tab: int) -> void:
	var children = spell_v_box.get_children()
	for child in children:
		child.queue_free()
	match tab:
		0:
			_create_fireball_tab()


func _create_fireball_tab() -> void:
	var attr_keys = fireball.attributes.keys()
	for key in attr_keys:
		var h_box:HBoxContainer = HBoxContainer.new()
		var l:Label = Label.new()
		l.text = key
		h_box.add_child(l)
		var upgrade_button:Button = Button.new()
		var attr_level = progress.spells.fireball[key]
		var next_level = attr_level + 1
		var has_next_level = fireball.attributes[key].size() >= next_level
		if has_next_level:
			upgrade_button.text = "Buy Level {0}".format([next_level])
			upgrade_button.pressed.connect(_purchase_upgrade.bind("fireball", key, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
		else:
			upgrade_button.text = "Complete"
			upgrade_button.disabled = true
		h_box.add_child(upgrade_button)
		if has_next_level:
			var cost: Label = Label.new()
			var attribute = fireball.attributes[key]
			cost.text = "{0} {1} {2} {3}".format(attribute[0].cost)
			h_box.add_child(cost)
		spell_v_box.add_child(h_box)


func _purchase_upgrade(spell:String, attribute:String, level:int, upgrade_button) -> void:
	print("purchase level {0} {1} for {2}".format([str(level), attribute, spell]))
	progress.spells[spell][attribute] = level
	progress.update(progress.spells, "spells")
	print(progress.spells[spell][attribute])
	var attr_level = progress.spells.fireball[attribute]
	var next_level = attr_level + 1
	var has_next_level = fireball.attributes[attribute].size() >= next_level
	if has_next_level:
		upgrade_button.text = "Buy Level {0}".format([next_level])
		upgrade_button.pressed.connect(_purchase_upgrade.bind("fireball", attribute, next_level, upgrade_button), ConnectFlags.CONNECT_ONE_SHOT)
	else:
		upgrade_button.text = "Complete"
		upgrade_button.disabled = true
