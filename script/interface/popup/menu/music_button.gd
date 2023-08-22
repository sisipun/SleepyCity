class_name MusicButton
extends SwitchButton


func _ready() -> void:
	EventStorage.game_updated.connect(_on_game_updated)


func _on_pressed() -> void:
	EventStorage.emit_signal("music_switch")


func _on_game_updated(game: GameInfo) -> void:
	set_is_on(game.music)
