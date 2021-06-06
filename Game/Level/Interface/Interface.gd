extends Control

signal init(level_number)
signal step_back
signal reset
signal tip
signal step(step_count)


export(String) var menu_path


func _on_reset_pressed() -> void:
	emit_signal("reset")


func _on_step_back_pressed() -> void:
	emit_signal("step_back")


func _on_tip_pressed() -> void:
	emit_signal("tip")


func _on_step(step_count: int) -> void:
	emit_signal("step", step_count)


func _on_menu_pressed() -> void:
	get_tree().change_scene(menu_path)


func _on_init(level_number) -> void:
	emit_signal("init", level_number)
