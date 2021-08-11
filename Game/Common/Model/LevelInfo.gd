extends Node


class_name LevelInfo


var width: int
var height: int
var targets: Array
var solution: Array
var initial: Array
var tutorial: bool


func _init(
		width: int, 
		height: int,
		targets: Array,
		solution: Array,
		initial: Array,
		tutorial: bool = false
	) -> void:
	self.width = width
	self.height = height
	self.targets = targets
	self.solution = solution
	self.initial = initial
	self.tutorial = tutorial
