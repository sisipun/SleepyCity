extends Control


func _ready():
	if Game.has_sound():
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Mute"
		Game.unmute()
	else:
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Unmute"
		Game.mute()

func _on_start_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_sound_pressed():
	if Game.has_sound():
		Game.mute()		
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Unmute"
	else:
		Game.unmute()		
		$MenuMargin/Buttons/FooterButtonsMargin/FooterButtons/SoundButton.text = "Mute"
