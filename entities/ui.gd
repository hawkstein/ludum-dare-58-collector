class_name MainUserInterface
extends CanvasLayer

@onready var loop_page = %LoopPage
@onready var upgrade_page = %UpgradePage
@onready var loop_count_label = %LoopCount

func _ready() -> void:
	loop_page.hide()
	upgrade_page.hide()


func show_loop(loop_count:int) -> void:
	upgrade_page.hide()
	loop_page.show()
	var previous_count = max(0, loop_count - 1)
	loop_count_label.text = "Loop: {0} + 1".format([previous_count])
	var t = Timer.new()
	add_child(t)
	t.start(2)
	await t.timeout
	t.queue_free()
	loop_count_label.text = "Loop: {0}".format([loop_count])
	

func show_upgrade() -> void:
	loop_page.hide()
	upgrade_page.show()
