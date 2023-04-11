extends SwitchButton


class_name SoundButton


func _ready() -> void:
	EventStorage.connect("game_updated", Callable(self, "_on_game_updated"))


func _on_pressed() -> void:
	EventStorage.emit_signal("sound_switch")


func _on_game_updated(game: GameInfo) -> void:
	set_is_on(game.sound)
