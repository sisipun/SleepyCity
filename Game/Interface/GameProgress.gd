extends ProgressBar


class_name GameProgress


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(level: LevelInfo, progress: int) -> void:
	value = progress
