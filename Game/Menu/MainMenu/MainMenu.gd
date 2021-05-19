extends Control


func _ready() -> void:
	if Game.has_sound():
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Mute"
		Game.unmute()
	else:
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Unmute"
		Game.mute()


func _on_start_pressed() -> void:
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_sound_pressed() -> void:
	if Game.has_sound():
		Game.mute()		
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Unmute"
	else:
		Game.unmute()		
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Mute"
