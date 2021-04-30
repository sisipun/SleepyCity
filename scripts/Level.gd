extends Node2D

class_name Level

enum Stage {
	USER_INPUT,
	CHECK,
	VIEW_RESULT
}

var level = Game.currentLevel()
var stage = Stage.USER_INPUT
var map = []
var user_input_map = []
var tips = []
var last_tip = 0
var step_number = 0
var alive_count = len(level.initial)
var attempt_count = 0

func _ready():
	var cellScene = load("res://scenes/Cell.tscn")	
	var game_area_size = $GameArea/GameAreaShape.shape.get_extents() * 2
	var game_area_position = $GameArea.position
	var cell_width = game_area_size.x / level.width
	var cell_height = game_area_size.y / level.height
	for i in range(level.width):
		map.append([])
		for j in range(level.height):
			var cell = cellScene.instance().init(
				i, 
				j, 
				Vector2(
					game_area_position.x + cell_width / 2 + i * cell_width, 
					game_area_position.y + cell_height / 2 + j * cell_height
				), 
				Vector2(
					cell_width, 
					cell_height
				),
				Vector2(i, j) in level.initial
			)
			map[i].append(cell)
			if Vector2(i, j) in level.targets:
				cell.play_target_effect()
			if Vector2(i, j) in level.solution:
				tips.push_back(cell)
			cell.connect("clicked", self, "_on_cell_clicked")
			add_child(cell)
			
	for i in range(level.step_count + 1):
		user_input_map.append([])
		for j in len(map):
			user_input_map[i].append([])
			for k in len(map[j]):
				user_input_map[i][j].append(map[j][k].is_alive())
			
	update_hud()

func _on_cell_clicked(cell):
	if stage == Stage.CHECK or step_number != 0 or Vector2(cell.coord_x, cell.coord_y) in level.initial:
		return
	
	if cell.is_alive():
		alive_count -= 1
		cell.change_alive(false)
		stage = Stage.USER_INPUT
	elif alive_count < level.alive_max_count:
		alive_count += 1
		cell.change_alive(true)
		stage = Stage.USER_INPUT
	
	update_neighbors_count()
	update_hud()
	user_input_map[step_number][cell.coord_x][cell.coord_y] = cell.is_alive()

func _on_tip_pressed():
	if stage == Stage.CHECK or not Game.has_tip():
		return
	
	var tip = last_tip + 1 if last_tip + 1 < tips.size() else 0
	var cell = tips[tip]
	if cell.play_tip_effect():
		last_tip = tip
		Game.decriment_tip()
		update_hud()

func _on_check_pressed():
	if stage == Stage.CHECK:
		return
	
	stage = Stage.CHECK
	attempt_count += 1
	$StepTimer.start()
	step_next()

func _on_back_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_step_pressed():
	if stage == Stage.VIEW_RESULT and step_number < level.step_count:
		step_next()

func _on_step_back_pressed():
	if stage == Stage.VIEW_RESULT and step_number > 0:
		step_previous()

func _on_step_timeout():
	if step_number < level.step_count:
		step_next()
		return
	
	if is_target_complete():
		complete()
	else:
		reset()

func step_next():
	step_number += 1
	update_status(step_number)
	update_neighbors_count()
	update_hud()

func step_previous():
	step_number -= 1
	reset_status(step_number)
	update_neighbors_count()
	update_hud()

func is_target_complete():
	for target in level.targets:
		if not map[target.x][target.y].is_alive():
			return false
	
	return true

func complete():
	Game.completeCurrentLevel(attempt_count)
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func reset():
	$StepTimer.stop()
	step_number = 0
	stage = Stage.VIEW_RESULT
	reset_status(0)
	update_neighbors_count()
	update_hud()

func update_neighbors_count():
	for i in range(map.size()):
		for j in range(map[i].size()):
			var neighbors_around_count = neighbors_around_count(i, j)
			map[i][j].set_neighbors_count(neighbors_around_count)

func update_status(step_number):
	for i in range(map.size()):
		for j in range(map[i].size()):
			var alive = map[i][j].is_alive()
			var alive_around_count = map[i][j].neighbors_count
			var new_alive = (
				(alive and alive_around_count in level.survive_condition) 
				or (not alive and alive_around_count in level.born_condition)
			)
			map[i][j].change_alive(new_alive)
			user_input_map[step_number][i][j] = new_alive

func reset_status(step_number):
	for i in range(map.size()):
		for j in range(map[i].size()):
			map[i][j].change_alive(user_input_map[step_number][i][j])

func neighbors_around_count(i, j):
	var inc_i = i + 1 if map.size() > i + 1 else 0
	var inc_j = j + 1 if map[i].size() > j + 1 else 0
	var counter = 0
	if map[i - 1][j].is_alive():
		counter += 1
	if map[i][j - 1].is_alive():
		counter += 1
	if map[inc_i][j].is_alive():
		counter += 1
	if map[i][inc_j].is_alive():
		counter += 1
	if map[i - 1][j - 1].is_alive():
		counter += 1
	if map[inc_i][inc_j].is_alive():
		counter += 1
	if map[i - 1][inc_j].is_alive():
		counter += 1
	if map[inc_i][j - 1].is_alive():
		counter += 1
	return counter

func update_hud():
	$HUD/ActiveCount.text = "Active count %d/%d" % [alive_count, level.alive_max_count]
	$HUD/TipButton.text = "Tip (%d left)" % Game.tip_count()
	$HUD/StepNumber.text = "Step: %d/%d" % [step_number, level.step_count]
	$HUD/CheckButton.disabled = alive_count != level.alive_max_count or step_number != 0
	$HUD/TipButton.disabled = not Game.has_tip()
	$HUD/StepButton.disabled = stage != Stage.VIEW_RESULT or step_number >= level.step_count
	$HUD/StepBackButton.disabled = stage != Stage.VIEW_RESULT or step_number <= 0
