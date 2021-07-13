extends Node

class GeneratedLevel:
	var solution: Array
	var cells: Array
	
	func _init(solution: Array, cells: Array):
		self.solution = solution
		self.cells = cells

static func generate_level(number: int, level_type: int) -> Storage.LevelInfo:
	var complexity = min(max(sqrt(number * 0.3 + 10), 3), 10)
	var width: int = floor(complexity)
	var height = width * 2
	var solution_size: int = (randi() % 3) + min(max(round(0.2 * complexity * complexity), 3), 20) - 1
	
	var level: Storage.LevelInfo
	if (level_type == Storage.LevelType.DARK):
		var generated: GeneratedLevel = _generate_level(width, width * 2, solution_size)
		level = Storage.LevelInfo.new(
			width,
			height,
			level_type,
			[],
			generated.solution,
			generated.cells
		)
	elif (level_type == Storage.LevelType.LIGHT):
		var generated: GeneratedLevel = _generate_level(width, width * 2, solution_size)
		level = Storage.LevelInfo.new(
			width,
			height,
			level_type,
			generated.cells,
			generated.solution,
			[]
		)
	return level

static func _generate_level(width: int, height: int, solution_size: int) -> GeneratedLevel:
	randomize()
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
	
	var cells = []
	for i in range(width):
		for j in range(height):
			if map[i][j]:
				cells.push_back(Vector2(i, j))
				
	return GeneratedLevel.new(
		solutions,
		cells
	)
