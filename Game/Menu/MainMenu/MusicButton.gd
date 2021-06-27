extends TextureButton

func _on_pressed() -> void:
	if Storage.has_music():
		Storage.mute_music()
	else:
		Storage.unmute_music()
