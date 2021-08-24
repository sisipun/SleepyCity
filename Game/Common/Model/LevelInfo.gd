extends Node


class_name LevelInfo


var width: int
var height: int
var targets: Array
var solution: Array
var initial: Array
var tutorial: bool


func _init(
		_width: int, 
		_height: int,
		_targets: Array,
		_solution: Array,
		_initial: Array,
		_tutorial: bool = false
	) -> void:
	self.width = _width
	self.height = _height
	self.targets = _targets
	self.solution = _solution
	self.initial = _initial
	self.tutorial = _tutorial
