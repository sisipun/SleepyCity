class_name Game
extends Node


func _ready() -> void:
	EventStorage.emit_signal("level_change_request", true)
