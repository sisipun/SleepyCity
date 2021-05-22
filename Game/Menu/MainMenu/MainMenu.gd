extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
