class_name LevelFailedSound
extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.level_failed.connect(_on_level_failed)


func _on_level_failed() -> void:
	play()
