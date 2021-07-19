extends Node


class_name Level


signal init(level_number, level_progress)


export (NodePath) var _level_area_path


onready var _level_area: LevelArea = get_node(_level_area_path)


var _level: LevelInfo


func _ready() -> void:
	_level_area.init(LevelController.get_current())
	emit_signal("init", LevelController.get_number(), LevelController.get_progress())


func _on_completed(steps_count: int, took_tip: bool) -> void:
	LevelController.complete_current(steps_count, took_tip)
