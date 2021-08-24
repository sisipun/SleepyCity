extends Node


class_name GameInfo


var preset_levels: Dictionary
var level: LevelInfo
var level_number: int
var tips_count: int
var sound: bool
var music: bool


func _init(
	_preset_levels: Dictionary,
	_level: LevelInfo = null,
	_level_number: int = 1,
	_tips_count: int = 3, 
	_sound: bool = true, 
	_music: bool = true
) -> void:
	self.preset_levels = _preset_levels
	self.level = _level
	self.level_number = _level_number
	self.tips_count = _tips_count
	self.sound = _sound
	self.music = _music
