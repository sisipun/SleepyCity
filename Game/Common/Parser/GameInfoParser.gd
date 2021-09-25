extends Node


func write(game: GameInfo) -> Dictionary:
	var dict_preset_levels: Dictionary = {}
	for preset_level_key in game.preset_levels:
		dict_preset_levels[preset_level_key] = LevelInfoParser.write(game.preset_levels[preset_level_key])
	var dict_level: Dictionary = LevelInfoParser.write(game.level) if game.level != null else null
	return {
		"dict_preset_levels": dict_preset_levels,
		"level": dict_level,
		"level_number": game.level_number,
		"tips_count": game.tips_count,
		"stars_count": game.stars_count,
		"sound": game.sound,
		"music": game.music
	}


func read(dict: Dictionary) -> GameInfo:
	var preset_levels: Dictionary = {}
	var dict_preset_levels: Dictionary = dict["dict_preset_levels"]
	for preset_level_key in dict_preset_levels:
		preset_levels[int(preset_level_key)] = LevelInfoParser.read(dict_preset_levels[preset_level_key])
	var dict_level = dict["level"]
	return GameInfo.new(
		preset_levels,
		LevelInfoParser.read(dict_level) if dict_level else null, 
		dict["level_number"],
		dict["tips_count"], 
		dict["stars_count"],
		dict["sound"],
		dict["music"]
	)
