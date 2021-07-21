extends SwitchButton


class_name SoundButton


func _ready():
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_pressed():
	EventStorage.emit_signal("sound_switch")


func _on_game_updated(game: GameInfo):
	set_is_on(game.sound)
