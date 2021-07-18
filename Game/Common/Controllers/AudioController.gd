extends Node


var sound_bus_name: String = "Sound"
var music_bus_name: String = "Music"


func _ready() -> void:
	play_sound(has_sound())
	play_music(has_music())


func has_sound() -> bool:
	return GameStorage.game.sound


func has_music() -> bool:
	return GameStorage.game.music


func play_sound(play: bool) -> void:
	GameStorage.game.sound = play
	AudioServer.set_bus_mute(AudioServer.get_bus_index(sound_bus_name), not play)
	GameStorage.save()


func play_music(play: bool) -> void:
	GameStorage.game.music = play
	AudioServer.set_bus_mute(AudioServer.get_bus_index(music_bus_name), not play)
	GameStorage.save()
