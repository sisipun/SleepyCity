extends SwitchButton


func _ready():
	set_is_on(Storage.has_music())


func _on_pressed():
	if Storage.has_music():
		Storage.mute_music()
	else:
		Storage.unmute_music()
