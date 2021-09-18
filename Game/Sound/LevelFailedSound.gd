extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("level_failed", self, "_on_level_failed")


func _on_level_failed() -> void:
	play()
