extends Control


class_name Interface


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset")


func _on_step_back_pressed() -> void:
	EventStorage.emit_signal("step_back")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	EventStorage.emit_signal("complete_current_level")


func _on_tutorial_pressed() -> void:
	EventStorage.emit_signal("tutorial_open", true)
