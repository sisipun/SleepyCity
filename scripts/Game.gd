extends Node

class Game:
	export(Array) var levels
	export(int) var tips_count
	
	func _init(levels, tips_count):
		self.levels = levels
		self.tips_count = tips_count
		
	func to_dict():
		var dict_levels = []
		for level in levels:
			dict_levels.push_back(level.to_dict())
		return {
			"levels": dict_levels,
			"tips_count": tips_count
		}
	
	static func from_dict(dict):
		var levels = []
		var dict_levels = dict["levels"]
		for level in dict_levels:
			levels.push_back(LevelInfo.from_dict(level))
		return Game.new(levels, dict["tips_count"])

class LevelInfo:
	export(int) var width
	export(int) var height
	export(int) var alive_max_count
	export(Array) var born_condition
	export(Array) var survive_condition
	export(int) var step_count
	export(Array)var targets
	export(Array)var solution
	export(bool) var completed
	export(int) var attempt_count
	export(bool) var opened

	func _init(width, height, alive_max_count, born_condition, survive_condition, step_count, targets, solution, opened, completed = false, attempt_count = 0):
		self.width = width
		self.height = height
		self.alive_max_count = alive_max_count
		self.born_condition = born_condition
		self.survive_condition = survive_condition
		self.step_count = step_count
		self.targets = targets
		self.solution = solution
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
		return {
			"width" : width,
			"height" : height,
			"alive_max_count" : alive_max_count,
			"born_condition" : born_condition,
			"survive_condition" : survive_condition,
			"step_count" : step_count,
			"targets" : dict_targets,
			"solution": dict_solution,
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
		return LevelInfo.new(
			dict["width"], 
			dict["height"], 
			dict["alive_max_count"],
			dict["born_condition"],
			dict["survive_condition"],
			dict["step_count"],
			targets,
			solution,
			dict["opened"],			
			dict["completed"],
			dict["attempt_count"]
		)

var game = Game.new([
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(3,4), Vector2(3,5), Vector2(4,4), Vector2(4,5)], [Vector2(3,4), Vector2(4,4), Vector2(4,5)], true),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 4, [3], [2,3], 2, [Vector2(3,4), Vector2(3,5), Vector2(4,4), Vector2(4,5), Vector2(5,4), Vector2(5,5)], [Vector2(4,4), Vector2(4,5), Vector2(4,6), Vector2(5,4)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false),
	LevelInfo.new(10, 20, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], [Vector2(3,5), Vector2(4,5), Vector2(5,5)], false)
], 10)
var currentLevelIndex = 0
var savePath = "res://saves/"
var saveFile = "levels.json"

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

func currentLevel():
	return game.levels[currentLevelIndex]
	
func completeCurrentLevel(attempt_count):
	var current = currentLevel()
	var levels = levels()
	if current.attempt_count == 0 or current.attempt_count > attempt_count:
		current.attempt_count = attempt_count
	current.completed = true
	var next = currentLevelIndex + 1
	if next < levels.size():
		levels[next].opened = true
	self.save()

func decriment_tip():
	game.tips_count -= 1
	self.save()

func save():
	var dir = Directory.new()
	if not dir.dir_exists(savePath):
		dir.make_dir(savePath)
		
	var file = File.new()
	file.open(savePath + saveFile, File.WRITE)
	file.store_line(to_json(game.to_dict()))
	file.close()
