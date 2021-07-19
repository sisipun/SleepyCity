extends SwitchButton


class_name MusicButton


func _ready():
	set_is_on(AudioController.has_music())


func _on_pressed():
	AudioController.play_music(not AudioController.has_music())
