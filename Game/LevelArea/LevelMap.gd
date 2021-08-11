extends Node


class_name LevelMap


var _info: LevelInfo
var _map: Array = []
var _steps: Array = []
var _steps_count = 0
var _solutions: Array = []
var _completed = false
var _solution_changed = true


func _init(info: LevelInfo) -> void:
	_info = info
	for i in range(_info.width):
		_map.append([])
		for j in range(_info.height):
			_map[i].append(Vector2(i, j) in _info.initial)
	for solution in info.solution:
		_solutions.push_back(solution)


func width() -> int:
	return _info.width


func height() -> int:
	return _info.height


func steps_count() -> int:
	return _steps_count


func solution() -> Vector2:
	return _solutions[0]


func solution_size() -> int:
	return len(_solutions)


func is_on(i: int, j: int) -> bool:
	return _map[i][j]


func is_target(i: int, j: int) -> bool:
	return Vector2(i, j) in _info.targets


func is_initial(i: int, j: int) -> bool:
	return Vector2(i, j) in _info.initial


func is_complete() -> bool:
	return _completed


func step(i: int, j: int) -> bool:
	if is_complete():
		return false
	
	var step: = Vector2(i, j)
	_steps.push_back(step)
	_steps_count += 1
	_step(i, j)
	
	var solution_index: = _solutions.find(step) 
	if solution_index < 0:
		_solutions.push_back(step)
	else: 
		_solutions.remove(solution_index)
	
	if _is_target_complete():
		_solutions.clear()
		_completed = true
	
	return true


func step_back() -> bool:
	if not _steps or is_complete():
		return false
	
	var step: Vector2 = _steps.pop_back()
	_step(step.x, step.y)
	
	var solution_index: = _solutions.find(step) 
	if solution_index < 0:
		_solutions.push_front(step)
	else: 
		_solutions.remove(solution_index)
	
	return true


func reset() -> bool:
	if not _steps or is_complete():
		return false
	
	_steps = []
	_solutions = []
	for i in range(_map.size()):
		for j in range(_map[i].size()):
			_map[i][j] = Vector2(i, j) in _info.initial
	for solution in _info.solution:
		_solutions.push_back(solution)
	return true


func _is_target_complete() -> bool:
	for target in _info.targets:
		if not _map[target.x][target.y]:
			return false

	for i in len(_map):
		for j in len(_map[i]):
			var targets_contains: bool = Vector2(i, j) in _info.targets
			if _map[i][j] and not targets_contains:
				return false
			elif not _map[i][j] and targets_contains:
				return false

	return true


func _step(x: int, y: int):
	var inc_x: int = x + 1 if _info.width > x + 1 else 0
	var inc_y: int = y + 1 if _info.height > y + 1 else 0
	
	_map[x][y] = not _map[x][y]
	_map[x - 1][y] = not _map[x - 1][y]
	_map[x][y - 1] = not _map[x][y - 1]
	_map[inc_x][y] = not _map[inc_x][y]
	_map[x][inc_y] = not _map[x][inc_y]
