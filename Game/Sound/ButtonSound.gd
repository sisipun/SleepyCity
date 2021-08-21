extends AudioStreamPlayer


class_name ButtonSound


func _ready() -> void:
	EventStorage.connect("sound_switch", self, "_on_button_pressed")
	EventStorage.connect("music_switch", self, "_on_button_pressed")
	EventStorage.connect("decrement_tip", self, "_on_button_pressed")
	EventStorage.connect("menu_open", self, "_on_button_pressed")
	EventStorage.connect("menu_closed", self, "_on_button_pressed")
	EventStorage.connect("tutorial_open", self, "_on_button_pressed")
	EventStorage.connect("tutorial_closed", self, "_on_button_pressed")


func _on_button_pressed() -> void:
	play()
