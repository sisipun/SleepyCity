class_name Level
extends Node


func _ready() -> void:
	EventStorage.emit_signal("level_change_request", true)
