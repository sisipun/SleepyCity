class_name LevelGenerator
extends Node


class GeneratedLevelMap extends LevelMap:
	
	
	func _init(map_width: int, map_height: int) -> void:
		_width = map_width
		_height = map_height
		_targets = []
		_solution = []
		_attempt_count = 0
		for i in range(_width):
			_map.append([])
			for j in range(_height):
				_map[i].append(false)
	
	
	func make_step(i: int, j: int) -> bool:
		var step: Vector2i = Vector2i(i, j)
		_steps.push_back(step)
		_make_step(i, j)
		return true
	
	
	func steps() -> Array[Vector2i]:
		return _steps
	
	
	func has_step(x: int, y: int) -> bool:
		return Vector2i(x, y) in _steps


class GeneratedLevel:
	
	
	var solution: Array[Vector2i]
	
	
	func _init(_solution: Array[Vector2i]) -> void:
		self.solution = _solution


static func generate_level(level_number: int) -> LevelInfo:
	randomize()
	
	var size_factor: float = sqrt(max(level_number, 1) * 0.3 + 10)
	var solution_size_factor: float = 0.2 * size_factor * size_factor
	
	var width: int = min(floor(size_factor), 6)
	var height = width * 2 - randi() % 2
	var solution_size: int = max(randi() % 3 + min(max(ceil(solution_size_factor), 3), 20) - 1, 3)
	
	var attempt_count = solution_size * 2
	
	var generated: GeneratedLevel = _generate_level(width, height, solution_size)
	return LevelInfo.new(
		width,
		height,
		[],
		generated.solution,
		[],
		attempt_count
	)


static func calculate_progress(level_number: int) -> int:
	return int(floor(fmod(sqrt(level_number), 1) * 100))


static func _generate_level(width: int, height: int, solution_size: int) -> GeneratedLevel:
	var map: GeneratedLevelMap = GeneratedLevelMap.new(width, height)
	
	while map.steps().size() < solution_size:
		var x: = randi() % width
		var y: = randi() % height
		
		if (not map.has_step(x, y)):
			map.make_step(x, y)
	
	return GeneratedLevel.new(
		map.steps()
	)
