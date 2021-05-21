extends Node

signal level_complete(level)
signal tip(tip_count)

class GameInfo:
	var levels: Array
	var tips_count: int
	var sound: bool
	
	func _init(levels, tips_count, sound) -> void:
		self.levels = levels
		self.tips_count = tips_count
		self.sound = sound
		
	func to_dict() -> Dictionary:
		var dict_levels: Array = []
		for level in levels:
			dict_levels.push_back(level.to_dict())
		return {
			"levels": dict_levels,
			"tips_count": tips_count,
			"sound": sound
		}
	
	static func from_dict(dict) -> GameInfo:
		var levels: Array = []
		var dict_levels: Array = dict["levels"]
		for level in dict_levels:
			levels.push_back(LevelInfo.from_dict(level))
		return GameInfo.new(levels, dict["tips_count"], dict["sound"])

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
			opened: bool, 
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
	
	static func from_dict(dict) -> LevelInfo:
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
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
			],
			false
		),
	],
	20,
	true
)
var _current_level_index: int = 0
var _save_path: String = "user://saves/"
var _save_file: String = "levels1.0.json"

func _ready() -> void:
	var file: = File.new()
	if not file.file_exists(_save_path + _save_file):
		return
	
	file.open(_save_path + _save_file, File.READ)
	_game = GameInfo.from_dict(JSON.parse(file.get_as_text()).result)
	file.close()

func levels() -> Array:
	return _game.levels

func tip_count() -> int:
	return _game.tips_count

func has_tip() -> bool:
	return _game.tips_count > 0
	
func has_sound() -> bool:
	return _game.sound

func set_current_level(index: int) -> void:
	_current_level_index = index

func get_current_level() -> LevelInfo:
	return _game.levels[_current_level_index]
	
func completeCurrentLevel(step_count: int) -> void:
	var current: LevelInfo = get_current_level()
	var levels: Array = levels()
	
	current.completed = true
	current.step_count = step_count
	if not current.bonus and len(current.solution) >= step_count:
		current.bonus = true
		_game.tips_count += 1
	
	var next: int = _current_level_index + 1
	if next < levels.size():
		_current_level_index = next
		levels[next].opened = true
	else:
		_current_level_index = 0
	save()
	emit_signal("level_complete", current)

func decriment_tip() -> void:
	_game.tips_count -= 1
	save()
	emit_signal("tip", _game.tips_count)
	
func mute() -> void:
	_game.sound = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	save()
	
func unmute() -> void:
	_game.sound = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	save()

func save() -> void:
	var dir: Directory = Directory.new()
	if not dir.dir_exists(_save_path):
		dir.make_dir(_save_path)
		
	var file: File = File.new()
	file.open(_save_path + _save_file, File.WRITE)
	file.store_line(to_json(_game.to_dict()))
	file.close()
