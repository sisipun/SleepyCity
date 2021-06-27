extends TextureButton

func _on_pressed() -> void:
	if Storage.has_sound():
		Storage.mute_sound()
	else:
		Storage.unmute_sound()
