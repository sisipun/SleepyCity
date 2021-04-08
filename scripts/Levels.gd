extends Node

var values = [
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)]),
	LevelInfo.new(20, 10, 3, [3], [2,3], 1, [Vector2(4,4), Vector2(4,5), Vector2(4,6)])
]
var current = 0

func current():
	return values[current]