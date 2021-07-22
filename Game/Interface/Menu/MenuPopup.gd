extends Popup


class_name MenuPopup


func _ready() -> void:
	EventStorage.connect("menu_open", self, "_on_menu_open")


func _on_menu_open() -> void:
	popup_centered()


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		hide()
