extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("level_complete", self, "_on_level_complete")


func _on_level_complete(steps_count: int, took_tip: bool) -> void:
	play()
