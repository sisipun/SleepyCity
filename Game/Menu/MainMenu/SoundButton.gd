extends Button


func _ready() -> void:
	if Storage.has_sound():
		text = "Mute"
	else:
		text = "Unmute"


func _on_pressed() -> void:
	if Storage.has_sound():
		Storage.mute()
		text = "Unmute"
	else:
		Storage.unmute()
		text = "Mute"
