extends Node


signal init(level_number)


func _ready() -> void:
	$LevelArea.set_level(Storage.get_current_level())
	emit_signal("init", Storage.get_current_level_index() + 1)


func _on_completed(steps_count: int, took_tip: bool) -> void:
	Storage.complete_story_level(steps_count, took_tip)
