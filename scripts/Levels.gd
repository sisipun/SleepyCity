extends Node

class LevelInfo:
	export(int) var width
	export(int) var height
	export(int) var alive_max_count
	export(Array) var born_condition
	export(Array) var survive_condition
	export(int) var step_count
	export(Array)var targets
	export(bool) var completed
	export(int) var attempt_count
	export(bool) var opened

	func _init(width, height, alive_max_count, born_condition, survive_condition, step_count, targets, opened, completed = false, attempt_count = 0):
		self.width = width
		self.height = height
		self.alive_max_count = alive_max_count
		self.born_condition = born_condition
		self.survive_condition = survive_condition
		self.step_count = step_count
		self.targets = targets
		self.opened = opened
		self.completed = completed
		self.attempt_count = attempt_count
		
	func to_dict():
		var dict_targets = []
		for target in targets:
			dict_targets.push_back({"x": target.x, "y":target.y})
		return {
			"width" : width,
			"height" : height,
			"alive_max_count" : alive_max_count,
			"born_condition" : born_condition,
			"survive_condition" : survive_condition,
			"step_count" : step_count,
			"targets" : dict_targets,
			"completed" : completed,
			"opened" : opened,
			"attempt_count" : attempt_count
		}
	
	static func from_dict(dict):
		var targets = []
		var dict_targets = dict["targets"]
		for target in dict_targets:
			targets.push_back(Vector2(target["x"], target["y"]))
		return LevelInfo.new(
			dict["width"], 
			dict["height"], 
			dict["alive_max_count"],
			dict["born_condition"],
			dict["survive_condition"],
			dict["step_count"],
			targets,
			dict["completed"],
			dict["opened"],
			dict["attempt_count"]
		)

var values = [
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)], true),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 4, [3], [2,3], 2, [Vector2(5,4), Vector2(5,5), Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false)
]
var currentIndex = 0

func _ready():
	self.loadLevels()
	for level in values:
		level.targets.sort()

func current():
	return values[currentIndex]
	
func completeCurrent(attempt_count):
	if current().attempt_count == 0 or current().attempt_count > attempt_count:
		current().attempt_count = attempt_count
	current().completed = true
	var next = currentIndex + 1
	if next < values.size():
		values[next].opened = true
	self.saveLevels()
		
func saveLevels():
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir("res://saves/")
		
	var file = File.new()
	file.open("res://saves/levels.json", File.WRITE)
	var store_values = []
	for value in values:
		store_values.push_back(value.to_dict())
	file.store_line(to_json(store_values))
	file.close()
	
func loadLevels():
	var file = File.new()
	if not file.file_exists("res://saves/levels.json"):
		return
	
	file.open("res://saves/levels.json", File.READ)
	var results = JSON.parse(file.get_as_text()).result
	var loaded_values = []
	for result in results:
		loaded_values.push_back(LevelInfo.from_dict(result))
	values = loaded_values
	file.close()
