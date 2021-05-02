extends Control


func _ready():
	if Game.has_sound():
		$Buttons/FooterButtons/SoundButton.text = "Mute"
		Game.unmute()
	else:
		$Buttons/FooterButtons/SoundButton.text = "Unmute"
		Game.mute()

func _on_start_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_sound_pressed():
	if Game.has_sound():
		Game.mute()		
		$Buttons/FooterButtons/SoundButton.text = "Unmute"
	else:
		Game.unmute()		
		$Buttons/FooterButtons/SoundButton.text = "Mute"
