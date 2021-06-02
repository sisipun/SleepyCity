extends Node

class_name Level

var _level: Storage.LevelInfo
var _map: Array = []
var _steps: Array = []
var _targets: Array = []
var _initial: Array = []
var _completed: = false


func _init(level: Storage.LevelInfo) -> void:
	_level = level
	for i in range(_level.width):
		_map.append([])
		for j in range(_level.height):
			_map[i].append(Vector2(i, j) in _level.initial)


func width() -> int:
	return _level.width


func height() -> int:
	return _level.height


func steps_count() -> int:
	return len(_steps)


func solution(i: int) -> Vector2:
	return _level.solution[i]


func solution_size() -> int:
	return len(_level.solution)


func is_alive(i: int, j: int) -> bool:
	return _map[i][j]


func is_target(i: int, j: int) -> bool:
	return Vector2(i, j) in _level.targets


func is_initial(i: int, j: int) -> bool:
	return Vector2(i, j) in _level.initial


func is_complete() -> bool:
	return _completed


func step(i: int, j: int) -> bool:
	if _completed:
		return false
	
	_steps.push_back(Vector2(i, j))	
	_step(i, j)
	
	if _is_target_complete():
		_completed = true
	
	return true

func step_back() -> bool:
	if not _steps or _completed:
		return false
	
	var step: Vector2 = _steps.pop_back()
	_step(step.x, step.y)
	
	return true


func reset() -> bool:
	if _completed:
		return false
	
	_steps = []
	for i in range(_map.size()):
		for j in range(_map[i].size()):
			_map[i][j] = Vector2(i, j) in _level.initial
	return true


func _is_target_complete() -> bool:
	for target in _level.targets:
		if not _map[target.x][target.y]:
			return false
	
	for i in len(_map):
		for j in len(_map[i]):
			var targets_contains: bool = Vector2(i, j) in _level.targets
			if _map[i][j] and not targets_contains:
				return false
			elif not _map[i][j] and targets_contains:
				return false
	
	return true

func _step(x: int, y: int):
	var inc_x: int = x + 1 if _level.width > x + 1 else 0
	var inc_y: int = y + 1 if _level.height > y + 1 else 0
	
	_map[x][y] = not _map[x][y]
	_map[x - 1][y] = not _map[x - 1][y]
	_map[x][y - 1] = not _map[x][y - 1]
	_map[inc_x][y] = not _map[inc_x][y]
	_map[x][inc_y] = not _map[x][inc_y]
	
