extends Node


signal level_complete(level, step_count, earned_bonuses, is_last_level, is_last_pack)
signal tip(tip_count)


class GameInfo:
	var packs: Array
	var current_pack: int
	var generated_count: int
	var tips_count: int
	var sound: bool
	var music: bool
	
	
	func _init(
		packs: Array, 
		current_pack: int = 0, 
		generated_count: int = 0, 
		tips_count: int = 20, 
		sound: bool = true, 
		music: bool = true
	) -> void:
		self.packs = packs
		self.current_pack = current_pack
		self.generated_count = generated_count
		self.tips_count = tips_count
		self.sound = sound
		self.music = music
	
	
	func to_dict() -> Dictionary:
		var dict_packs: Array = []
		for pack in packs:
			dict_packs.push_back(pack.to_dict())
		return {
			"packs": dict_packs,
			"current_pack": current_pack,
			"generated_count": generated_count,
			"tips_count": tips_count,
			"sound": sound,
			"music": music
		}
	
	
	static func from_dict(dict: Dictionary) -> GameInfo:
		var packs: Array = []
		var dict_packs: Array = dict["packs"]
		for pack in dict_packs:
			packs.push_back(PackInfo.from_dict(pack))
		return GameInfo.new(
			packs, 
			dict["current_pack"], 
			dict["generated_count"], 
			dict["tips_count"], 
			dict["sound"],
			dict["music"]
		)


class PackInfo:
	var levels: Array
	var current_level: int
	var opened: bool
	
	
	func _init(levels: Array, current_level: int, opened: bool = false) -> void:
		self.levels = levels
		self.current_level = current_level
		self.opened = opened
	
	
	func to_dict() -> Dictionary:
		var dict_levels: Array = []
		for level in levels:
			dict_levels.push_back(level.to_dict())
		return {
			"levels": dict_levels,
			"current_level": current_level,
			"opened": opened
		}
	
	
	static func from_dict(dict: Dictionary) -> PackInfo:
		var levels: Array = []
		var dict_levels: Array = dict["levels"]
		for level in dict_levels:
			levels.push_back(LevelInfo.from_dict(level))
		return PackInfo.new(levels, dict["current_level"], dict["opened"])


class LevelInfo:
	var width: int
	var height: int
	var targets: Array
	var solution: Array
	var initial: Array
	var opened: bool
	var completed: bool
	var bonus: bool
	var step_count: int
	
	
	func _init(
			width: int, 
			height: int, 
			targets: Array,
			solution: Array,
			initial: Array, 
			opened: bool = false, 
			completed: bool = false, 
			bonus: bool = false, 
			step_count: int = 0
		) -> void:
		self.width = width
		self.height = height
		self.targets = targets
		self.solution = solution
		self.initial = initial
		self.opened = opened
		self.completed = completed
		self.bonus = bonus
		self.step_count = step_count
	
	
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
			"initial": dict_initial,
			"completed" : completed,
			"opened" : opened,
			"bonus" : bonus,
			"step_count" : step_count
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
			initial,
			dict["opened"],
			dict["completed"],
			dict["bonus"],
			dict["step_count"]
		)

var _game: GameInfo = GameInfo.new(
	[
		PackInfo.new([
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(1,4), 
					Vector2(2,3), 
					Vector2(2,4),
					Vector2(2,5),
					Vector2(3,4),
				], 
				[
					Vector2(2,4)
				],
				[
				],
				true
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5), 
					Vector2(3,3), 
					Vector2(3,4),
					Vector2(3,5),
					Vector2(4,4),
				], 
				[
					Vector2(1,4),
					Vector2(3,4)
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(2,5), 
					Vector2(2,6),
					Vector2(3,5),
				],
				[
					Vector2(1,4),
					Vector2(2,5)
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(2,5), 
					Vector2(3,6),
					Vector2(3,7),
					Vector2(4,6),
				],
				[
					Vector2(1,4),
					Vector2(2,5),
					Vector2(3,6)
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,5), 
					Vector2(2,3), 
					Vector2(2,5),
					Vector2(3,4),
				], 
				[
					Vector2(1,4),
					Vector2(2,4)
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(0,5), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5), 
					Vector2(1,6), 
					Vector2(2,3), 
					Vector2(2,4), 
					Vector2(2,5),
					Vector2(2,6),
					Vector2(3,4),
					Vector2(3,5),
				], 
				[
					Vector2(1,4),
					Vector2(1,5),
					Vector2(2,4),
					Vector2(2,5),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(1,4), 
					Vector2(2,2), 
					Vector2(2,3), 
					Vector2(2,5),
					Vector2(2,6),
					Vector2(3,4),
					Vector2(4,4),
				], 
				[
					Vector2(1,4),
					Vector2(2,3),
					Vector2(2,5),
					Vector2(3,4),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,4), 
					Vector2(2,2), 
					Vector2(2,4), 
					Vector2(2,6),
					Vector2(4,4),
				], 
				[
					Vector2(1,4),
					Vector2(2,3),
					Vector2(2,4),
					Vector2(2,5),
					Vector2(3,4),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,3), 
					Vector2(0,5), 
					Vector2(1,2), 
					Vector2(1,3), 
					Vector2(1,5),
					Vector2(1,6),
					Vector2(3,2),
					Vector2(3,3),
					Vector2(3,5),
					Vector2(3,6),
					Vector2(4,3),
					Vector2(4,5),
				], 
				[
					Vector2(1,3),
					Vector2(1,5),
					Vector2(3,3),
					Vector2(3,5),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(0,5), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5),
					Vector2(2,3),
					Vector2(2,4),
					Vector2(2,5),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
					Vector2(4,3),
					Vector2(4,4),
					Vector2(4,5),
				], 
				[
					Vector2(0,4),
					Vector2(1,4),
					Vector2(2,4),
					Vector2(3,4),
					Vector2(4,4),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,6), 
					Vector2(1,4), 
					Vector2(2,2), 
					Vector2(2,3), 
					Vector2(2,4),
					Vector2(3,4),
					Vector2(4,6),
				], 
				[
					Vector2(0,5),
					Vector2(1,4),
					Vector2(2,3),
					Vector2(3,4),
					Vector2(4,5),
				],
				[
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
					Vector2(0,3), 
					Vector2(0,5), 
					Vector2(1,3), 
					Vector2(1,5),
					Vector2(2,1),
					Vector2(2,2),
					Vector2(2,3),
					Vector2(2,5),
					Vector2(2,6),
					Vector2(2,7),
					Vector2(3,3),
					Vector2(3,5),
					Vector2(4,3),
					Vector2(4,5),
				], 
				[
					Vector2(1,3),
					Vector2(1,5),
					Vector2(2,2),
					Vector2(2,6),
					Vector2(3,3),
					Vector2(3,5),
				],
				[
				]
			),
		], 
		0, 
		true
		),
		PackInfo.new([
			LevelInfo.new(
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
					Vector2(3,4),
				],
				true
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,4),
					Vector2(3,4)
				],
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5), 
					Vector2(3,3), 
					Vector2(3,4),
					Vector2(3,5),
					Vector2(4,4),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,4),
					Vector2(2,4),
					Vector2(3,4),
				],
				[
					Vector2(0,4), 
					Vector2(1,3), 
					Vector2(1,5), 
					Vector2(2,3), 
					Vector2(2,4), 
					Vector2(2,5),
					Vector2(3,3),
					Vector2(3,5),
					Vector2(4,4),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,5),
					Vector2(2,3),
					Vector2(2,7),
					Vector2(3,5),
				],
				[
					Vector2(0,5), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5), 
					Vector2(1,6),
					Vector2(1,7),
					Vector2(2,2),
					Vector2(2,3),
					Vector2(2,4),
					Vector2(2,6),
					Vector2(2,7),
					Vector2(2,8),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
					Vector2(3,6),
					Vector2(3,7),
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(0,4),
					Vector2(1,4),
					Vector2(2,2),
					Vector2(2,3),
					Vector2(2,5),
					Vector2(2,6),
					Vector2(3,4),
					Vector2(4,4),
				],
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(0,5),
					Vector2(1,2), 
					Vector2(1,6), 
					Vector2(2,1), 
					Vector2(2,7), 
					Vector2(3,2),
					Vector2(3,6),
					Vector2(4,3),
					Vector2(4,4),
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,3),
					Vector2(1,4),
					Vector2(1,5),
					Vector2(2,3),
					Vector2(2,5),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
				],
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(0,5), 
					Vector2(1,2), 
					Vector2(1,3), 
					Vector2(1,4), 
					Vector2(1,5),
					Vector2(1,6),
					Vector2(2,2),
					Vector2(2,3),
					Vector2(2,5),
					Vector2(2,6),
					Vector2(3,2),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
					Vector2(3,6),
					Vector2(4,3),
					Vector2(4,4),
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,3),
					Vector2(1,4),
					Vector2(1,5),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
				],
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(0,5), 
					Vector2(1,2), 
					Vector2(1,4), 
					Vector2(1,6), 
					Vector2(3,2),
					Vector2(3,4),
					Vector2(3,6),
					Vector2(4,3),
					Vector2(4,4),
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,3),
					Vector2(1,4),
					Vector2(1,5),
					Vector2(2,4),
					Vector2(3,3),
					Vector2(3,4),
					Vector2(3,5),
				],
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(0,5), 
					Vector2(1,2), 
					Vector2(1,6), 
					Vector2(2,3), 
					Vector2(2,4), 
					Vector2(2,5), 
					Vector2(3,2),
					Vector2(3,6),
					Vector2(4,3),
					Vector2(4,4),
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,5),
					Vector2(2,3),
					Vector2(2,4),
					Vector2(2,5),
					Vector2(3,5),
				],
				[
					Vector2(0,5), 
					Vector2(1,3), 
					Vector2(1,6), 
					Vector2(2,2), 
					Vector2(2,4), 
					Vector2(2,6), 
					Vector2(3,3), 
					Vector2(3,6), 
					Vector2(4,5),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(1,3),
					Vector2(1,4),
					Vector2(2,5),
					Vector2(3,3),
					Vector2(3,4),
				],
				[
					Vector2(0,3), 
					Vector2(0,4), 
					Vector2(1,2), 
					Vector2(2,4), 
					Vector2(2,5), 
					Vector2(2,6), 
					Vector2(3,2), 
					Vector2(4,3), 
					Vector2(4,4),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(2,0),
					Vector2(2,2),
					Vector2(2,4),
					Vector2(2,6),
					Vector2(2,8),
				],
				[
					Vector2(1,0), 
					Vector2(2,0), 
					Vector2(3,0), 
					Vector2(1,2), 
					Vector2(2,2), 
					Vector2(3,2), 
					Vector2(1,4), 
					Vector2(2,4), 
					Vector2(3,4), 
					Vector2(1,6),
					Vector2(2,6),
					Vector2(3,6),
					Vector2(1,8),
					Vector2(2,8),
					Vector2(3,8),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(0,0),
					Vector2(1,1),
					Vector2(2,2),
					Vector2(3,3),
					Vector2(4,4),
					Vector2(0,5),
					Vector2(1,6),
					Vector2(2,7),
					Vector2(3,8),
					Vector2(4,9),
				],
				[
					Vector2(0,0),
					Vector2(1,1),
					Vector2(2,2),
					Vector2(3,3),
					Vector2(4,4),
					Vector2(0,5),
					Vector2(1,6),
					Vector2(2,7),
					Vector2(3,8),
					Vector2(4,9),
				]
			),
			LevelInfo.new(
				5,
				10, 
				[
				], 
				[
					Vector2(0,0),
					Vector2(2,1),
					Vector2(4,2),
					Vector2(1,3),
					Vector2(3,4),
					Vector2(0,5),
					Vector2(2,6),
					Vector2(4,7),
					Vector2(1,8),
					Vector2(3,9),
				],
				[
					Vector2(0,0), 
					Vector2(1,0), 
					Vector2(2,0), 
					Vector2(3,0), 
					Vector2(4,0),
					Vector2(0,1), 
					Vector2(1,1), 
					Vector2(2,1), 
					Vector2(3,1), 
					Vector2(4,1),
					Vector2(0,2), 
					Vector2(1,2), 
					Vector2(2,2), 
					Vector2(3,2), 
					Vector2(4,2),
					Vector2(0,3), 
					Vector2(1,3), 
					Vector2(2,3), 
					Vector2(3,3), 
					Vector2(4,3),
					Vector2(0,4), 
					Vector2(1,4), 
					Vector2(2,4), 
					Vector2(3,4), 
					Vector2(4,4),
					Vector2(0,5), 
					Vector2(1,5), 
					Vector2(2,5), 
					Vector2(3,5), 
					Vector2(4,5),
					Vector2(0,6), 
					Vector2(1,6), 
					Vector2(2,6), 
					Vector2(3,6), 
					Vector2(4,6),
					Vector2(0,7), 
					Vector2(1,7), 
					Vector2(2,7), 
					Vector2(3,7), 
					Vector2(4,7),
					Vector2(0,8), 
					Vector2(1,8), 
					Vector2(2,8), 
					Vector2(3,8), 
					Vector2(4,8),
					Vector2(0,9), 
					Vector2(1,9), 
					Vector2(2,9), 
					Vector2(3,9), 
					Vector2(4,9), 
				]
			)
		], 
		0
		)
	]
)


var _save_path: String = "user://saves/"
var _save_file: String = "levels1.0.json"
var _current_version: String = "1"


func _ready() -> void:
	var file: = File.new()
	if not file.file_exists(_save_path + _save_file):
		return
	
	file.open(_save_path + _save_file, File.READ)
	var data: Dictionary = JSON.parse(file.get_as_text()).result
	var version: String = data["version"]
	if version != _current_version:
		# TODO add migration
		return
	
	_game = GameInfo.from_dict(data)
	file.close()
	
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


func get_current_pack() -> PackInfo:
	return _game.packs[_game.current_pack]


func get_current_levels() -> Array:
	return _game.packs[_game.current_pack].levels


func get_generated_count() -> int:
	return _game.generated_count


func get_current_version() -> String:
	return _current_version


func set_current_pack(index: int) -> void:
	_game.current_pack = index
	save()


func get_current_level() -> LevelInfo:
	var pack: PackInfo = get_current_pack()
	return pack.levels[pack.current_level]


func get_current_level_index() -> int:
	var pack: PackInfo = get_current_pack()
	return pack.current_level


func set_current_level(index: int) -> void:
	var pack: PackInfo = get_current_pack()
	pack.current_level = index
	save()


func complete_story_level(step_count: int, took_tip: bool) -> void:
	var current: LevelInfo = get_current_level()
	var pack: PackInfo = get_current_pack()
	var earned_bonuses: = 0
	
	current.completed = true
	if current.step_count > step_count:
		current.step_count = step_count
	if not current.bonus and not took_tip and len(current.solution) >= step_count:
		current.bonus = true
		earned_bonuses = 1
		_game.tips_count += earned_bonuses
	
	var next_level: int = pack.current_level + 1
	var is_last_level: bool = next_level >= pack.levels.size()
	var next_pack: int = _game.current_pack + 1
	var is_last_pack: bool = next_pack >= _game.packs.size()
	if not is_last_level:
		pack.current_level = next_level
		pack.levels[next_level].opened = true
	elif not is_last_pack:
		_game.packs[next_pack].opened = true
	
	save()
	emit_signal("level_complete", current, step_count, earned_bonuses, is_last_level, is_last_pack)


func complete_generated_level(info: LevelInfo, step_count: int, took_tip: bool) -> void:
	var pack: PackInfo = get_current_pack()
	var earned_bonuses: int = 0
	
	_game.generated_count += 1
	if not took_tip and len(info.solution) >= step_count:
		earned_bonuses = min(max(info.width / 3, 1), 3)
		_game.tips_count += earned_bonuses
	
	save()
	emit_signal("level_complete", info, step_count, earned_bonuses, false, false)


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
