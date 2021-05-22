extends Button


func _ready() -> void:
	if Game.has_sound():
		text = "Mute"
	else:
		text = "Unmute"


func _on_pressed() -> void:
	if Game.has_sound():
		Game.mute()
		text = "Unmute"
	else:
		Game.unmute()
		text = "Mute"
