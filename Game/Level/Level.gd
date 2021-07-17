extends Node


signal init(level_number)


var _level: Storage.LevelInfo


func _ready() -> void:
	$LevelArea.init(Storage.get_level())
	emit_signal("init", Storage.get_level_number() + 1)


func _on_completed(steps_count: int, took_tip: bool) -> void:
	Storage.complete_level(steps_count, took_tip)
