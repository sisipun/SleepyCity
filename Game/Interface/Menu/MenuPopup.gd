extends Popup


class_name MenuPopup


func _ready() -> void:
	EventStorage.connect("menu_open", self, "_on_menu_open")


func _on_menu_open() -> void:
	popup_centered()


func _on_close() -> void:
	hide()
	EventStorage.emit_signal("menu_closed")
