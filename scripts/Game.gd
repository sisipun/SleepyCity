extends Node

class Game:
	export(Array) var levels
	export(int) var tips_count
	export(bool) var sound
	
	func _init(levels, tips_count, sound):
		self.levels = levels
		self.tips_count = tips_count
		self.sound = sound
		
	func to_dict():
		var dict_levels = []
		for level in levels:
			dict_levels.push_back(level.to_dict())
		return {
			"levels": dict_levels,
			"tips_count": tips_count,
			"sound": sound
		}
	
	static func from_dict(dict):
		var levels = []
		var dict_levels = dict["levels"]
		for level in dict_levels:
			levels.push_back(LevelInfo.from_dict(level))
		return Game.new(levels, dict["tips_count"], dict["sound"])

class LevelInfo:
	export(int) var width
	export(int) var height
	export(int) var alive_max_count
	export(Array) var born_condition
	export(Array) var survive_condition
	export(int) var step_count
	export(Array) var targets
	export(Array) var solution
	export(Array) var initial
	export(bool) var completed
	export(int) var attempt_count
	export(bool) var opened

	func _init(width, height, alive_max_count, born_condition, survive_condition, step_count, targets, solution, initial, opened, completed = false, attempt_count = 0):
		self.width = width
		self.height = height
		self.alive_max_count = alive_max_count
		self.born_condition = born_condition
		self.survive_condition = survive_condition
		self.step_count = step_count
		self.targets = targets
		self.solution = solution
		self.initial = initial
		self.opened = opened
		self.completed = completed
		self.attempt_count = attempt_count
		
	func to_dict():
		var dict_targets = []
		for target in targets:
			dict_targets.push_back({"x": target.x, "y":target.y})
		var dict_solution = []
		for solution_item in solution:
			dict_solution.push_back({"x": solution_item.x, "y":solution_item.y})
		var dict_initial = []
		for initial_item in initial:
			dict_initial.push_back({"x": initial_item.x, "y":initial_item.y})
		return {
			"width" : width,
			"height" : height,
			"alive_max_count" : alive_max_count,
			"born_condition" : born_condition,
			"survive_condition" : survive_condition,
			"step_count" : step_count,
			"targets" : dict_targets,
			"solution": dict_solution,
			"initial": dict_initial,
			"completed" : completed,
			"opened" : opened,
			"attempt_count" : attempt_count
		}
	
	static func from_dict(dict):
		var targets = []
		var dict_targets = dict["targets"]
		for target in dict_targets:
			targets.push_back(Vector2(target["x"], target["y"]))
		var solution = []
		var dict_solution = dict["solution"]
		for solution_item in dict_solution:
			solution.push_back(Vector2(solution_item["x"], solution_item["y"]))
		var initial = []
		var dict_initial = dict["initial"]
		for initial_item in dict_initial:
			initial.push_back(Vector2(initial_item["x"], initial_item["y"]))
		return LevelInfo.new(
			dict["width"], 
			dict["height"], 
			dict["alive_max_count"],
			dict["born_condition"],
			dict["survive_condition"],
			dict["step_count"],
			targets,
			solution,
			initial,
			dict["opened"],			
			dict["completed"],
			dict["attempt_count"]
		)

var game = Game.new(
	[
		LevelInfo.new(
			4, 
			8, 
			3, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,3), 
				Vector2(1,4), 
				Vector2(2,3), 
				Vector2(2,4)
			], 
			[
				Vector2(1,3), 
				Vector2(2,3), 
				Vector2(2,4)
			],
			[
			],
			true
		),
		LevelInfo.new(
			5, 
			10, 
			3, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(2,3), 
				Vector2(2,4),
				Vector2(2,5)
			], 
			[
				Vector2(1,4), 
				Vector2(2,4), 
				Vector2(3,4)
			],
			[
			], 
			false
		),
		LevelInfo.new(
			5, 
			10, 
			4, 
			[3], 
			[2,3], 
			2, 
			[
				Vector2(1,4), 
				Vector2(1,5), 
				Vector2(2,4),
				Vector2(2,5), 
				Vector2(3,4), 
				Vector2(3,5)
			], 
			[
				Vector2(2,4),
				Vector2(2,5), 
				Vector2(2,6), 
				Vector2(3,4)
			], 
			[
			], 
			false
		),
		LevelInfo.new(
			6, 
			12, 
			6, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,5), 
				Vector2(1,6), 
				Vector2(2,4), 
				Vector2(3,7), 
				Vector2(4,5), 
				Vector2(4,6)
			], 
			[
				Vector2(2,5), 
				Vector2(2,6), 
				Vector2(3,5), 
				Vector2(3,6),
			], 
			[
				Vector2(1,5), 
				Vector2(4,6)
			], 
			false
		),
		LevelInfo.new(
			6, 
			12, 
			6, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,4), 
				Vector2(1,5), 
				Vector2(2,4), 
				Vector2(2,5), 
				Vector2(3,6), 
				Vector2(3,7), 
				Vector2(4,6), 
				Vector2(4,7)
			], 
			[
				Vector2(1,5), 
				Vector2(2,4), 
				Vector2(3,7), 
				Vector2(4,6)
			], 
			[
				Vector2(1,4), 
				Vector2(4,7)
			], 
			false
		),
		LevelInfo.new(
			6, 
			12, 
			6, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,6), 
				Vector2(2,4), 
				Vector2(2,6), 
				Vector2(3,5), 
				Vector2(3,7), 
				Vector2(4,5)
			], 
			[
				Vector2(2,7),
				Vector2(3,4),
			],
			[
				Vector2(1,5), 
				Vector2(2,6),
				Vector2(3,5),
				Vector2(4,6)
			], 
			false
		),
		LevelInfo.new(
			7, 
			14, 
			5, 
			[3], 
			[2,3], 
			2, 
			[
				Vector2(1,7), 
				Vector2(2,6), 
				Vector2(2,8), 
				Vector2(3,5), 
				Vector2(3,9), 
				Vector2(4,6), 
				Vector2(4,8), 
				Vector2(5,7)
			], 
			[
				Vector2(2,7), 
				Vector2(3,6), 
				Vector2(3,8), 
				Vector2(4,7)
			], 
			[
				Vector2(3,7)
			], 
			false
		),
		LevelInfo.new(
			7, 
			14, 
			8, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,5), 
				Vector2(1,6), 
				Vector2(2,5), 
				Vector2(2,7), 
				Vector2(4,7), 
				Vector2(4,9), 
				Vector2(5,8),
				Vector2(5,9)
			], 
			[
				Vector2(3,6), 
				Vector2(3,8)
			], 
			[
				Vector2(1,5),
				Vector2(1,6),
				Vector2(2,5),
				Vector2(4,9), 
				Vector2(5,8),
				Vector2(5,9)
			],
			false
		),
		LevelInfo.new(
			8,
			16,
			9,
			[3],
			[2,3],
			1, 
			[
				Vector2(1,5),
				Vector2(1,6),
				Vector2(2,5),
				Vector2(3,6),
				Vector2(3,8),
				Vector2(5,8),
				Vector2(5,10),
				Vector2(6,9),
				Vector2(6,10)
			], 
			[
				Vector2(2,7),
				Vector2(4,7),
				Vector2(4,9),
			], 
			[
				Vector2(1,5),
				Vector2(1,6),
				Vector2(2,5),
				Vector2(5,10),
				Vector2(6,9),
				Vector2(6,10)
			], 
			false
		),
		LevelInfo.new(
			8, 
			16, 
			16, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,5), 
				Vector2(1,6),
				Vector2(1,9),
				Vector2(1,10),
				Vector2(2,5),
				Vector2(2,7),
				Vector2(2,10),
				Vector2(3,9),
				Vector2(4,6),
				Vector2(5,5),
				Vector2(5,8),
				Vector2(5,10),
				Vector2(6,5),
				Vector2(6,6),
				Vector2(6,9),
				Vector2(6,10)
			], 
			[
				Vector2(2,8),
				Vector2(3,6),
				Vector2(4,9),
				Vector2(5,7)
			], 
			[
				Vector2(1,5),
				Vector2(1,6),
				Vector2(1,9),
				Vector2(1,10),
				Vector2(2,5),
				Vector2(2,10),
				Vector2(5,5),
				Vector2(5,10),
				Vector2(6,5),
				Vector2(6,6),
				Vector2(6,9),
				Vector2(6,10)
			], 
			false
		),
		LevelInfo.new(
			9, 
			18, 
			16, 
			[3], 
			[2,3], 
			1, 
			[
				Vector2(1,9), 
				Vector2(1,10), 
				Vector2(2,5), 
				Vector2(2,6), 
				Vector2(2,10), 
				Vector2(3,5),
				Vector2(3,7),
				Vector2(3,9),
				Vector2(5,7),
				Vector2(5,9),
				Vector2(5,11),
				Vector2(6,6),
				Vector2(6,10),
				Vector2(6,11),
				Vector2(7,6),
				Vector2(7,7)
			], 
			[
				Vector2(2,8),
				Vector2(4,6),
				Vector2(4,10),
				Vector2(6,8),
			], 
			[
				Vector2(1,9),
				Vector2(1,10),
				Vector2(2,5),
				Vector2(2,6),
				Vector2(2,10),
				Vector2(3,5),
				Vector2(5,11),
				Vector2(6,6),
				Vector2(6,10),
				Vector2(6,11),
				Vector2(7,6),
				Vector2(7,7)
			], 
			false
		)
	], 
	20,
	true
)
var currentLevelIndex = 0
var savePath = "user://saves/"
var saveFile = "levels1.0.json"

func _ready():
	var file = File.new()
	if not file.file_exists(savePath + saveFile):
		return
	
	file.open(savePath + saveFile, File.READ)
	game = Game.from_dict(JSON.parse(file.get_as_text()).result)
	file.close()

func levels():
	return game.levels

func tip_count():
	return game.tips_count

func has_tip():
	return game.tips_count > 0
	
func has_sound():
	return game.sound

func currentLevel():
	return game.levels[currentLevelIndex]
	
func completeCurrentLevel(attempt_count):
	var current = currentLevel()
	var levels = levels()
	if current.attempt_count == 0 or current.attempt_count > attempt_count:
		current.attempt_count = attempt_count
		game.tips_count += 1 if attempt_count == 1 else 0
	current.completed = true
	var next = currentLevelIndex + 1
	if next < levels.size():
		currentLevelIndex = next
		levels[next].opened = true
	else:
		currentLevelIndex = 0
	self.save()

func decriment_tip():
	game.tips_count -= 1
	save()
	
func mute():
	game.sound = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	save()
	
func unmute():
	game.sound = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	save()

func save():
	var dir = Directory.new()
	if not dir.dir_exists(savePath):
		dir.make_dir(savePath)
		
	var file = File.new()
	file.open(savePath + saveFile, File.WRITE)
	file.store_line(to_json(game.to_dict()))
	file.close()
