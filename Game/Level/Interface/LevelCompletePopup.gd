extends Popup

signal back_to_menu
signal next

func _ready() -> void:
	Game.connect("level_complete", self, "_on_level_complete")


func _on_level_complete(level: Game.LevelInfo) -> void:
	popup_centered()
	var step = level.step_count
	$Menu/StepLabel.text = "%d/%d" % [level.step_count, len(level.solution)]


func _on_menu_pressed() -> void:
	emit_signal("back_to_menu")


func _on_next_pressed() -> void:
	emit_signal("next")
