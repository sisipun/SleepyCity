extends Node


signal init(level_number)


var _level: Storage.LevelInfo


func _ready() -> void:
	var generated_count: = Storage.get_generated_count()
	var width: int = min(max(sqrt(generated_count + 10), 3), 10)
	var solution_size: int = randi() % 3 + (min(max(round(0.2 * width * width), 3), 20) - 1)
	_level = generate(width, width * 2, solution_size)
	$LevelArea.set_level(_level)
	emit_signal("init", Storage.get_generated_count() + 1)


func _on_completed(steps_count: int, took_tip: bool) -> void:
	Storage.complete_generated_level(_level, steps_count, took_tip)


func generate(width: int, height: int, solution_size: int) -> Storage.LevelInfo:
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
	
	var initial = []
	for i in range(width):
		for j in range(height):
			if map[i][j]:
				initial.push_back(Vector2(i, j))
				
	return Storage.LevelInfo.new(
		width, 
		height,
		[],
		solutions,
		initial
	)
