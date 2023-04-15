class_name LevelMap
extends Node


var _info: LevelInfo
var _map: Array[Array] = []
var _steps: Array[Vector2] = []
var _solution_steps: Array[Vector2] = []
var _completed: bool = false


func _init(info: LevelInfo) -> void:
	_info = info
	for i in range(_info.width):
		_map.append([])
		for j in range(_info.height):
			_map[i].append(Vector2(i, j) in _info.initial)
	for solution in info.solution:
		_solution_steps.push_back(solution)


func width() -> int:
	return _info.width


func height() -> int:
	return _info.height


func step_number() -> int:
	return len(_steps)


func next_step_solution() -> Vector2:
	return _solution_steps[0]


func solution_size() -> int:
	return len(_solution_steps)


func attempts_left() -> int:
	return _info.attempt_count - step_number()


func has_attempts() -> bool:
	return attempts_left() > 0


func is_on(i: int, j: int) -> bool:
	return _map[i][j]


func is_target(i: int, j: int) -> bool:
	return Vector2(i, j) in _info.targets


func is_initial(i: int, j: int) -> bool:
	return Vector2(i, j) in _info.initial


func is_complete() -> bool:
	return _completed


func make_step(i: int, j: int) -> bool:
	if is_complete():
		return false
	
	var step: Vector2 = Vector2(i, j)
	_steps.push_back(step)
	_make_step(i, j)
	
	var solution_step_index: = _solution_steps.find(step) 
	if solution_step_index < 0:
		_solution_steps.push_back(step)
	else: 
		_solution_steps.remove_at(solution_step_index)
	
	if _is_target_complete():
		_solution_steps.clear()
		_completed = true
	
	return true


func step_back() -> bool:
	if _steps.is_empty() or is_complete():
		return false
	
	var step: Vector2 = _steps.pop_back()
	_make_step(int(step.x), int(step.y))
	
	var solution_step_index: = _solution_steps.find(step) 
	if solution_step_index < 0:
		_solution_steps.push_front(step)
	else: 
		_solution_steps.remove_at(solution_step_index)
	
	return true


func reset() -> bool:
	if _steps.is_empty() or is_complete():
		return false
	
	_steps = []
	_solution_steps = []
	for i in range(_map.size()):
		for j in range(_map[i].size()):
			_map[i][j] = Vector2(i, j) in _info.initial
	for solution_step in _info.solution:
		_solution_steps.push_back(solution_step)
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


func _make_step(x: int, y: int) -> void:
	var inc_x: int = x + 1 if _info.width > x + 1 else 0
	var inc_y: int = y + 1 if _info.height > y + 1 else 0
	
	_map[x][y] = not _map[x][y]
	_map[x - 1][y] = not _map[x - 1][y]
	_map[x][y - 1] = not _map[x][y - 1]
	_map[inc_x][y] = not _map[inc_x][y]
	_map[x][inc_y] = not _map[x][inc_y]
