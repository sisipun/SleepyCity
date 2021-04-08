extends Node2D

class_name Level

enum Stage {
	USER_INPUT,
	PREVIEW
}

export var width = 20
export var height = 10
export var alive_max_count = 3
export var born_condition = [3]
export var survive_condition = [2, 3]
export var step_count = 1
export var targets = [Vector2(4,4), Vector2(4,5), Vector2(3,4), Vector2(3,5)]

var screen_size
var stage = Stage.USER_INPUT
var map = []
var user_input_map = []
var step_number = 0
var alive_count = 0

func _ready():
	var levelInfo = Levels.current()
	self.width = levelInfo.width
	self.height = levelInfo.height
	self.alive_max_count = levelInfo.alive_max_count
	self.born_condition = levelInfo.born_condition
	self.survive_condition = levelInfo.survive_condition
	self.step_count = levelInfo.step_count
	self.targets = levelInfo.targets
	
	var cellScene = load("res://scenes/Cell.tscn")
	screen_size = get_viewport_rect().size
	stage = Stage.USER_INPUT
	var cell_width = screen_size.x / width
	var cell_height = screen_size.y / height
	for i in range(width):
		map.append([])
		user_input_map.append([])
		for j in range(height):
			var cell = cellScene.instance().init(i, j, Vector2(cell_width / 2 + i * cell_width, cell_height / 2 + j * cell_height), Vector2(cell_width, cell_height))
			cell.connect("clicked", self, "_on_Cell_clicked")
			add_child(cell)
			map[i].append(cell)
			user_input_map[i].append(cell.is_alive())
			
	targets.sort()	
	for target in targets:
		var cell = cellScene.instance().init(target.x, target.y, Vector2(cell_width / 2 + target.x * cell_width, cell_height / 2 + target.y * cell_height), Vector2(cell_width, cell_height), 0.5, Cell.Type.TARGET)
		add_child(cell)
	
	$HUD/ActiveCount.text = "Active count %d/%d" % [alive_count, alive_max_count]
	$HUD/ActiveCount.show()

func _on_Cell_clicked(coord_x, coord_y):
	if stage == Stage.PREVIEW:
		return
	
	var cell = map[coord_x][coord_y]
	if not cell.is_alive() and alive_count < alive_max_count:
		alive_count += 1
		cell.set_alive(true)
	elif cell.is_alive():
		alive_count -= 1
		cell.set_alive(false)

	user_input_map[coord_x][coord_y] = cell.is_alive()	
	if alive_count == alive_max_count:
		$HUD/ActiveCount.hide()
		$HUD/PreviewButton.show()
	else:
		$HUD/PreviewButton.hide()
		$HUD/ActiveCount.text = "Active count %d/%d" % [alive_count, alive_max_count]
		$HUD/ActiveCount.show()

func _on_PreviewButton_pressed():
	if stage == Stage.PREVIEW:
		return
		
	stage = Stage.PREVIEW
	$HUD/StepNumber.text = "Step: %d/%d" % [step_number, step_count]
	$HUD/StepNumber.show()
	$StepTimer.start()

func _on_StepTimer_timeout():
	step_number += 1
	if step_number > step_count:
		$StepTimer.stop()
		step_number = 0
		if not is_target_complete():
			stage = Stage.USER_INPUT
			reset_map()
	else: 
		step()
		$HUD/StepNumber.text = "Step: %d/%d" % [step_number, step_count]

func step():
	var new_statuses = []
	for i in range(map.size()):
		new_statuses.append([])
		for j in range(map[i].size()):
			var alive = map[i][j].is_alive()
			var alive_around_count = alive_around_count(i, j)
			new_statuses[i].append((alive and alive_around_count in survive_condition) or (not alive and alive_around_count in born_condition))
	
	for i in range(new_statuses.size()):
		for j in range(new_statuses[i].size()):
			map[i][j].set_alive(new_statuses[i][j])

func reset_map():
	for i in range(map.size()):
		for j in range(map[i].size()):
			map[i][j].set_alive(user_input_map[i][j])
	
	$HUD/StepNumber.hide()
	
func alive_around_count(i, j):
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
	
func is_target_complete():
	var active_cells = []
	for i in range(map.size()):
		for j in range(map[i].size()):
			if map[i][j].is_alive():
				active_cells.append(Vector2(i, j))
	active_cells.sort()
	return active_cells == targets
