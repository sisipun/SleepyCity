extends Node

class LevelInfo:
	var width
	var height
	var alive_max_count
	var born_condition
	var survive_condition
	var step_count
	var targets
	var completed
	var opened

	func _init(width, height, alive_max_count, born_condition, survive_condition, step_count, targets, completed, opened):
		self.width = width
		self.height = height
		self.alive_max_count = alive_max_count
		self.born_condition = born_condition
		self.survive_condition = survive_condition
		self.step_count = step_count
		self.targets = targets
		self.completed = completed
		self.opened = opened

var values = [
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)], false, true),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)], false, false),
	LevelInfo.new(20, 10, 4, [3], [2,3], 2, [Vector2(5,4), Vector2(5,5), Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)], false, false)
]
var current = 0

func _ready():
	for level in values:
		level.targets.sort()

func current():
	return values[current]
	
func completeCurrent():
	current().completed = true
	var next = current + 1
	if next < values.size():
		values[next].opened = true