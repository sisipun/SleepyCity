extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("sound_switch", self, "_on_sound_switch")
	EventStorage.connect("music_switch", self, "_on_music_switch")
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")
	EventStorage.connect("step_back", self, "_on_step_back")
	EventStorage.connect("reset", self, "_on_reset")
	EventStorage.connect("menu_open", self, "_on_menu_open")
	EventStorage.connect("menu_closed", self, "_on_menu_closed")


func _on_sound_switch():
	play()


func _on_music_switch():
	play()


func _on_decrement_tip():
	play()


func _on_step_back():
	play()


func _on_reset():
	play()


func _on_menu_open():
	play()


func _on_menu_closed():
	play()
