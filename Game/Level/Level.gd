extends Node


signal init(level_number)


var _level: Storage.LevelInfo


func _ready() -> void:
	$LevelArea.set_level(Storage.get_generated_level())
	emit_signal("init", Storage.get_generated_count() + 1)


func _on_completed(steps_count: int, took_tip: bool) -> void:
	Storage.complete_generated_level(steps_count, took_tip)
