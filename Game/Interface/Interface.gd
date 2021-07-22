extends Control


class_name Interface


func _ready() -> void:
	margin_top = OS.get_window_safe_area().position.y


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset")


func _on_step_back_pressed() -> void:
	EventStorage.emit_signal("step_back")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")
