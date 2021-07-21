extends Control


class_name Interface


signal step_back
signal reset
signal menu
signal step(step_count)


func _ready() -> void:
	margin_top = OS.get_window_safe_area().position.y


func _on_reset_pressed() -> void:
	emit_signal("reset")


func _on_step_back_pressed() -> void:
	emit_signal("step_back")


func _on_step(step_count: int) -> void:
	emit_signal("step", step_count)


func _on_menu_pressed() -> void:
	emit_signal("menu")
