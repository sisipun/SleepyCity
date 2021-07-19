extends ProgressBar


class_name GameProgress


func _on_init(level_number: int, level_progress: int) -> void:
	value = level_progress
