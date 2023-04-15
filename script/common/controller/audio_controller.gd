class_name AudioController
extends Node


var sound_bus_name: String = "Sound"
var music_bus_name: String = "Music"


func _ready() -> void:
	play_sound(GameStorage.game.sound)
	play_music(GameStorage.game.music)
	EventStorage.sound_switch.connect(_on_sound_switch)
	EventStorage.music_switch.connect(_on_music_switch)


func _on_sound_switch() -> void:
	play_sound(not GameStorage.game.sound)


func _on_music_switch() -> void:
	play_music(not GameStorage.game.music) 


func play_sound(play: bool) -> void:
	GameStorage.game.sound = play
	AudioServer.set_bus_mute(AudioServer.get_bus_index(sound_bus_name), not play)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func play_music(play: bool) -> void:
	print(AudioServer.get_bus_index(music_bus_name))
	GameStorage.game.music = play
	AudioServer.set_bus_mute(AudioServer.get_bus_index(music_bus_name), not play)
	EventStorage.emit_signal("game_updated", GameStorage.game)
