extends Node2D

class_name Level

enum Stage {
	USER_INPUT,
	PREVIEW
}

var level = Game.currentLevel()
var stage = Stage.USER_INPUT
var map = []
var user_input_map = []
var tips = []
var last_tip = 0
var step_number = 0
var alive_count = 0
var attempt_count = 0

func _ready():
	var cellScene = load("res://scenes/Cell.tscn")	
	var screen_size = get_viewport_rect().size
	var cell_width = screen_size.x / level.width
	var cell_height = screen_size.y / level.height
	for i in range(level.width):
		map.append([])
		user_input_map.append([])
		for j in range(level.height):
			var cell = cellScene.instance().init(
				i, 
				j, 
				Vector2(
					cell_width / 2 + i * cell_width, 
					cell_height / 2 + j * cell_height
				), 
				Vector2(
					cell_width, 
					cell_height
				)
			)
			map[i].append(cell)
			user_input_map[i].append(cell.is_alive())
			if Vector2(i, j) in level.targets:
				cell.play_target_effect()
			if Vector2(i, j) in level.solution:
				tips.push_back(cell)
			cell.connect("clicked", self, "_on_cell_clicked")			
			add_child(cell)
			
	$HUD/ActiveCount.text = "Active count %d/%d" % [alive_count, level.alive_max_count]
	$HUD/TipButton.text = "Tip (%d left)" % Game.tip_count()
	$HUD/StepNumber.text = "Step: %d" % [level.step_count - step_number]
	$HUD/PreviewButton.disabled = alive_count != level.alive_max_count
	$HUD/TipButton.disabled = not Game.has_tip()

func _on_cell_clicked(cell):
	if stage == Stage.PREVIEW:
		return
	
	if cell.is_alive():
		alive_count -= 1
		cell.change_alive(false)
	elif alive_count < level.alive_max_count:
		alive_count += 1
		cell.change_alive(true)

	update_neighbors_count()
	user_input_map[cell.coord_x][cell.coord_y] = cell.is_alive()
	$HUD/ActiveCount.text = "Active count %d/%d" % [alive_count, level.alive_max_count]	
	$HUD/PreviewButton.disabled = alive_count != level.alive_max_count

func _on_tip_pressed():
	if stage == Stage.PREVIEW or not Game.has_tip():
		return
	
	var tip = last_tip + 1 if last_tip + 1 < tips.size() else 0
	var cell = tips[tip]
	if cell.play_tip_effect():
		last_tip = tip
		Game.decriment_tip()
		$HUD/TipButton.text = "Tip (%d left)" % Game.tip_count()
	if not Game.has_tip():
		$HUD/TipButton.disabled = true

func _on_preview_pressed():
	if stage == Stage.PREVIEW:
		return
		
	stage = Stage.PREVIEW
	attempt_count += 1
	$StepTimer.start()
	
func _on_back_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_step_timeout():
	step_number += 1
	if step_number <= level.step_count:
		update_status()
		update_neighbors_count()		
		$HUD/StepNumber.text = "Step: %d" % [level.step_count - step_number]
		return
		
	if is_target_complete():
		complete()
	else:
		reset()

func is_target_complete():
	for target in level.targets:
		if not map[target.x][target.y].is_alive():
			return false
	
	return true

func reset():
	$StepTimer.stop()
	step_number = 0
	stage = Stage.USER_INPUT
	for i in range(map.size()):
		for j in range(map[i].size()):
			map[i][j].change_alive(user_input_map[i][j])
	
	$HUD/StepNumber.text = "Step: %d" % [level.step_count - step_number]

func complete():
	Game.completeCurrentLevel(attempt_count)
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func update_neighbors_count():
	for i in range(map.size()):
		for j in range(map[i].size()):
			var neighbors_around_count = neighbors_around_count(i, j)
			map[i][j].set_neighbors_count(neighbors_around_count)

func update_status():
	for i in range(map.size()):
		for j in range(map[i].size()):
			var alive = map[i][j].is_alive()
			var alive_around_count = map[i][j].neighbors_count
			map[i][j].change_alive(
				(alive and alive_around_count in level.survive_condition) or
				(not alive and alive_around_count in level.born_condition)
			)

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
