extends Node


signal init(level_number, level_progress)


var _level: LevelInfo


func _ready() -> void:
	$LevelArea.init(LevelController.get_current())
	emit_signal("init", LevelController.get_number(), LevelController.get_progress())


func _on_completed(steps_count: int, took_tip: bool) -> void:
	LevelController.complete_current(steps_count, took_tip)
