extends Popup


func _on_menu() -> void:
	popup_centered()


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		hide()
