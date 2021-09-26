extends AudioStreamPlayer


class_name ButtonSound


func _ready() -> void:
	EventStorage.connect("sound_switch", self, "_on_button_pressed")
	EventStorage.connect("music_switch", self, "_on_button_pressed")
	EventStorage.connect("decrement_tip", self, "_on_button_pressed")
	EventStorage.connect("menu_open", self, "_on_button_pressed")
	EventStorage.connect("menu_closed", self, "_on_button_pressed")
	EventStorage.connect("tutorial_open", self, "_on_tutorial_button_pressed")
	EventStorage.connect("tutorial_closed", self, "_on_button_pressed")
	EventStorage.connect("tutorial_next", self, "_on_button_pressed")
	EventStorage.connect("tutorial_previous", self, "_on_button_pressed")


func _on_button_pressed() -> void:
	play()


func _on_tutorial_button_pressed(initial: bool) -> void:
	if not initial:
		play()
