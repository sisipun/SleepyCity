extends Node


class_name GameInfo


var preset_levels: Dictionary
var level: LevelInfo
var level_number: int
var tips_count: int
var sound: bool
var music: bool


func _init(
	preset_levels: Dictionary,
	level: LevelInfo = null,
	level_number: int = 1,
	tips_count: int = 20, 
	sound: bool = true, 
	music: bool = true
) -> void:
	self.preset_levels = preset_levels
	self.level = level
	self.level_number = level_number
	self.tips_count = tips_count
	self.sound = sound
	self.music = music
