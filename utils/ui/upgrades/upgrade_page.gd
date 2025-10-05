extends Control

@onready var grimoire_v_box: VBoxContainer = %GrimoireVBox
@onready var collector_v_box: VBoxContainer = %CollectorVBox
@onready var tower_v_box: VBoxContainer = %TowerVBox

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
