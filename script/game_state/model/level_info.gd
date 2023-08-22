class_name LevelInfo
extends Node


var width: int
var height: int
var targets: Array[Vector2i]
var solution: Array[Vector2i]
var initial: Array[Vector2i]
var attempt_count: int
var tutorial: bool


func _init(
	_width: int, 
	_height: int,
	_targets: Array[Vector2i],
	_solution: Array[Vector2i],
	_initial: Array[Vector2i],
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
