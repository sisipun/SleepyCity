extends HBoxContainer


func _ready() -> void:
	if Storage.has_sound():
		$SoundButton.text = "Sound off"
	else:
		$SoundButton.text = "Sound on"
		
	if Storage.has_music():
		$MusicButton.text = "Music off"
	else:
		$MusicButton.text = "Music on"


func _on_sound_pressed() -> void:
	if Storage.has_sound():
		Storage.mute_sound()
		$SoundButton.text = "Sound on"
	else:
		Storage.unmute_sound()
		$SoundButton.text = "Sound off"


func _on_music_pressed() -> void:
	if Storage.has_music():
		Storage.mute_music()
		$MusicButton.text = "Music on"
	else:
		Storage.unmute_music()
		$MusicButton.text = "Music off"
