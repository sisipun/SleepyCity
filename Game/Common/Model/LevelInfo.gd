extends Node


class_name LevelInfo


var width: int
var height: int
var targets: Array
var solution: Array
var initial: Array
var attempt_count: int
var tutorial: bool


func _init(
		_width: int, 
		_height: int,
		_targets: Array,
		_solution: Array,
		_initial: Array,
		_attempt_count: int,
		_tutorial: bool = false
	) -> void:
	self.width = _width
	self.height = _height
	self.targets = _targets
	self.solution = _solution
	self.initial = _initial
	self.attempt_count = _attempt_count
	self.tutorial = _tutorial
