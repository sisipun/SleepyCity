extends Node


func _ready() -> void:
	$LevelArea.set_level(Storage.get_current_level())


func _on_completed(steps_count: int, took_tip: bool) -> void:
	Storage.complete_story_level(steps_count, took_tip)
