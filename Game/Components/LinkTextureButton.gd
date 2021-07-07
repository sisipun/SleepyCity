extends Node


export (String) var link_path


func _on_pressed() -> void:
	get_tree().change_scene(link_path)
