extends Node


signal level_complete(level, step_count, earned_bonuses)
signal tip(tip_count)


class GameInfo:
	var preset_levels: Dictionary
	var generated_level: LevelInfo
	var generated_count: int
	var tips_count: int
	var sound: bool
	var music: bool
	
	
	func _init(
		preset_levels: Dictionary,
		generated_level: LevelInfo = null,
		generated_count: int = 0,
		tips_count: int = 20, 
		sound: bool = true, 
		music: bool = true
	) -> void:
		self.preset_levels = preset_levels
		self.generated_level = generated_level
		self.generated_count = generated_count
		self.tips_count = tips_count
		self.sound = sound
		self.music = music
	
	
	func to_dict() -> Dictionary:
		var dict_preset_levels: Dictionary = {}
		for preset_level_key in preset_levels:
			dict_preset_levels[preset_level_key] = preset_levels[preset_level_key].to_dict()
		return {
			"dict_preset_levels": dict_preset_levels,
			"generated_level": generated_level.to_dict() if generated_level != null else null, 
			"generated_count": generated_count,
			"tips_count": tips_count,
			"sound": sound,
			"music": music
		}
	
	
	static func from_dict(dict: Dictionary) -> GameInfo:
		var preset_levels: Dictionary = {}
		var dict_preset_levels: Dictionary = dict["dict_preset_levels"]
		for preset_level_key in dict_preset_levels:
			preset_levels[preset_level_key] = LevelInfo.from_dict(dict_preset_levels[preset_level_key])
		var dict_generated_level = dict["generated_level"]
		return GameInfo.new(
			preset_levels,
			LevelInfo.from_dict(dict_generated_level) if dict_generated_level else null, 
			dict["generated_count"],
			dict["tips_count"], 
			dict["sound"],
			dict["music"]
		)


enum LevelType { LIGHT = 0, DARK = 1, MIXED = 2 }

class LevelInfo:
	var width: int
	var height: int
	var type: int
	var targets: Array
	var solution: Array
	var initial: Array
	
	func _init(
			width: int, 
			height: int, 
			targets: Array,
			solution: Array,
			initial: Array
		) -> void:
		self.width = width
		self.height = height
		self.targets = targets
		self.solution = solution
		self.initial = initial
	
	func to_dict() -> Dictionary:
		var dict_targets: Array = []
		for target in targets:
			dict_targets.push_back({"x": target.x, "y":target.y})
		var dict_solution: Array = []
		for solution_item in solution:
			dict_solution.push_back({"x": solution_item.x, "y":solution_item.y})
		var dict_initial: Array = []
		for initial_item in initial:
			dict_initial.push_back({"x": initial_item.x, "y":initial_item.y})
		return {
			"width" : width,
			"height" : height,
			"targets" : dict_targets,
			"solution": dict_solution,
			"initial": dict_initial
		}
	
	
	static func from_dict(dict: Dictionary) -> LevelInfo:
		var targets: Array = []
		var dict_targets: Array = dict["targets"]
		for target in dict_targets:
			targets.push_back(Vector2(target["x"], target["y"]))
		var solution: Array = []
		var dict_solution: Array = dict["solution"]
		for solution_item in dict_solution:
			solution.push_back(Vector2(solution_item["x"], solution_item["y"]))
		var initial: Array = []
		var dict_initial: Array = dict["initial"]
		for initial_item in dict_initial:
			initial.push_back(Vector2(initial_item["x"], initial_item["y"]))
		return LevelInfo.new(
			dict["width"], 
			dict["height"], 
			targets,
			solution,
			initial
		)

var _game: GameInfo = GameInfo.new({
	0: LevelInfo.new(
		5,
		10, 
		[
		], 
		[
			Vector2(2,4)
		],
		[
			Vector2(1,4), 
			Vector2(2,3), 
			Vector2(2,4),
			Vector2(2,5),
			Vector2(3,4)
		]
	)
})
var _save_path: String = "user://saves/"
var _save_file: String = "levels1.0.json"
var _current_version: String = "1"


func _ready() -> void:
	var file: = File.new()
	if not file.file_exists(_save_path + _save_file):
		return
	
	file.open(_save_path + _save_file, File.READ)
	var data: Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	
	var version: String = data["version"]
	if version != _current_version:
		save()
	else:
		_game = GameInfo.from_dict(data)
	
	if has_sound():
		unmute_sound()
	else:
		mute_sound()
		
	if has_music():
		unmute_music()
	else:
		mute_music()


func tip_count() -> int:
	return _game.tips_count


func has_tip() -> bool:
	return _game.tips_count > 0


func has_sound() -> bool:
	return _game.sound


func has_music() -> bool:
	return _game.music


func packs() -> Array:
	return _game.packs


func get_generated_count() -> int:
	return _game.generated_count


func get_generated_level() -> LevelInfo:
	if _game.generated_level != null:
		return _game.generated_level
	
	randomize()
	var levelType = randi() % (LevelType.MIXED + 1)
	_game.generated_level = _game.preset_levels[_game.generated_count] if _game.preset_levels.has(_game.generated_count) else LevelGenerator.generate_level(_game.generated_count, levelType)
	save()
	return _game.generated_level


func get_current_version() -> String:
	return _current_version

func complete_generated_level(step_count: int, took_tip: bool) -> void:
	var info: LevelInfo = _game.generated_level
	var earned_bonuses: int = 0
	
	_game.generated_level = null
	_game.generated_count += 1
	if not took_tip and len(info.solution) >= step_count:
		earned_bonuses = min(max(info.width / 3, 1), 3)
		_game.tips_count += earned_bonuses
	
	save()
	emit_signal("level_complete", info, step_count, earned_bonuses)


func decriment_tip() -> void:
	_game.tips_count -= 1
	save()
	emit_signal("tip", _game.tips_count)


func mute_sound() -> void:
	_game.sound = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), true)
	save()


func unmute_sound() -> void:
	_game.sound = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), false)
	save()


func mute_music() -> void:
	_game.music = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	save()


func unmute_music() -> void:
	_game.music = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	save()


func save() -> void:
	var dir: Directory = Directory.new()
	if not dir.dir_exists(_save_path):
		dir.make_dir(_save_path)
		
	var data: Dictionary = _game.to_dict()
	data["version"] = _current_version
	var file: File = File.new()
	file.open(_save_path + _save_file, File.WRITE)
	file.store_line(to_json(data))
	file.close()
