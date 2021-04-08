class_name LevelInfo

var width
var height
var alive_max_count
var born_condition
var survive_condition
var step_count
var targets

func _init(width, height, alive_max_count, born_condition, survive_condition, step_count, targets):
	self.width = width
	self.height = height
	self.alive_max_count = alive_max_count
	self.born_condition = born_condition
	self.survive_condition = survive_condition
	self.step_count = step_count
	self.targets = targets