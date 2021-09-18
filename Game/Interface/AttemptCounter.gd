extends Label


class_name AttemptCounter


func _ready() -> void:
	EventStorage.connect("step", self, "_on_step")
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_step(_step_number: int, attempts_left: int):
	text = str(attempts_left)


func _on_level_changed(
	_initial: bool,
	info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	text = str(info.attempt_count)
