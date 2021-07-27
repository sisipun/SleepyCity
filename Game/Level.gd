extends Node


func _ready() -> void:
	EventStorage.emit_signal("level_loaded")
