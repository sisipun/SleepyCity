extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(
	level: LevelInfo, 
	level_number: int, 
	previous_progress: int, 
	current_progress: int, 
	earned_bonus: bool
) -> void:
	play()
