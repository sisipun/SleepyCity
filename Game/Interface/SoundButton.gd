extends SwitchButton


func _ready():
	set_is_on(Storage.has_sound())


func _on_pressed():
	if Storage.has_sound():
		Storage.mute_sound()
	else:
		Storage.unmute_sound()
