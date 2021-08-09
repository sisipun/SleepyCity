extends Node


class GeneratedLevel:
	var solution: Array
	var cells: Array
	
	func _init(solution: Array, cells: Array):
		self.solution = solution
		self.cells = cells


func generate_level(number: int, level_type: int) -> LevelInfo:
	randomize()
	
	var size_factor: float = sqrt(max(number - 10, 1) * 0.3 + 10)
	var solution_size_factor: float = 0.2 * size_factor * size_factor
	
	var width: int = min(floor(size_factor), 6)
	var height = width * 2 - (randi() % 2)
	var rand_part = (randi() % 3)
	var solution_size: int = rand_part + min(max(ceil(solution_size_factor), 3), 20) - 1
	
	var level: LevelInfo
	var generated: GeneratedLevel = _generate_level(width, height, solution_size)
	return LevelInfo.new(
		width,
		height,
		level_type,
		[],
		generated.solution,
		generated.cells
	)


func _generate_level(width: int, height: int, solution_size: int) -> GeneratedLevel:
	var map: = []
	for i in range(width):
		map.push_back([])
		for j in range(height):
			map[i].push_back(false)
	
	var solutions = []
	var solution_index: = 0
	while solution_index < solution_size:
		var x: = randi() % width
		var y: = randi() % height
		
		var inc_x: int = x + 1 if width > x + 1 else 0
		var inc_y: int = y + 1 if height > y + 1 else 0
	
		map[x][y] = not map[x][y]
		map[x - 1][y] = not map[x - 1][y]
		map[x][y - 1] = not map[x][y - 1]
		map[inc_x][y] = not map[inc_x][y]
		map[x][inc_y] = not map[x][inc_y]
		
		var exists_solution = solutions.find(Vector2(x, y)) 
		if exists_solution == -1:
			solutions.push_back(Vector2(x, y))
			solution_index += 1
		else:
			solutions.remove(exists_solution)
			solution_index -= 1
	
	var cells = []
	for i in range(width):
		for j in range(height):
			if map[i][j]:
				cells.push_back(Vector2(i, j))
				
	return GeneratedLevel.new(
		solutions,
		cells
	)
