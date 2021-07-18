extends SwitchButton


func _ready():
	set_is_on(AudioController.has_sound())


func _on_pressed():
	AudioController.play_sound(not AudioController.has_sound())
