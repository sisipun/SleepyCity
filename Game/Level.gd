extends Node


func _ready() -> void:
	EventStorage.emit_signal("next_level", true)
