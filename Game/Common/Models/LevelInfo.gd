extends Node


class_name LevelInfo


enum LevelType { DARK = 0, LIGHT = 1 }


var width: int
var height: int
var type: int
var targets: Array
var solution: Array
var initial: Array
var tutorial: bool


func _init(
		width: int, 
		height: int,
		type: int,
		targets: Array,
		solution: Array,
		initial: Array,
		tutorial: bool = false
	) -> void:
	self.width = width
	self.height = height
	self.type = type
	self.targets = targets
	self.solution = solution
	self.initial = initial
	self.tutorial = tutorial
