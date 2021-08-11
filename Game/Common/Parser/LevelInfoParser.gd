extends Node


func write(level: LevelInfo) -> Dictionary:
	var dict_targets: Array = []
	for target in level.targets:
		dict_targets.push_back({"x": target.x, "y":target.y})
	var dict_solution: Array = []
	for solution_item in level.solution:
		dict_solution.push_back({"x": solution_item.x, "y":solution_item.y})
	var dict_initial: Array = []
	for initial_item in level.initial:
		dict_initial.push_back({"x": initial_item.x, "y":initial_item.y})
	return {
		"width" : level.width,
		"height" : level.height,
		"targets" : dict_targets,
		"solution": dict_solution,
		"initial": dict_initial,
		"tutorial": level.tutorial
	}



func read(dict: Dictionary) -> LevelInfo:
	var targets: Array = []
	var dict_targets: Array = dict["targets"]
	for target in dict_targets:
		targets.push_back(Vector2(target["x"], target["y"]))
	var solution: Array = []
	var dict_solution: Array = dict["solution"]
	for solution_item in dict_solution:
		solution.push_back(Vector2(solution_item["x"], solution_item["y"]))
	var initial: Array = []
	var dict_initial: Array = dict["initial"]
	for initial_item in dict_initial:
		initial.push_back(Vector2(initial_item["x"], initial_item["y"]))
	return LevelInfo.new(
		dict["width"], 
		dict["height"], 
		targets,
		solution,
		initial,
		dict["tutorial"]
	)
