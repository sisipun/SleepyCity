extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	_earned_bonus: bool
) -> void:
	play()
