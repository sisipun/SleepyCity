extends Node2D

export (PackedScene) var Cell
export var width = 100
export var height = 50
export var alive_max_count = 10
export var born_condition = [3]
export var survive_condition = [2, 3]
export var step_count = 5

var user_map = []
var map = []
var screen_size
var step = 0
var alive_count = 0

func _ready():
	screen_size = get_viewport_rect().size	
	var cell_width = screen_size.x / width
	var cell_height = screen_size.y / height
	for i in range(width):
		map.append([])
		user_map.append([])
		for j in range(height):
			var cell = Cell.instance().init(i, j, false, Vector2(cell_width / 2 + i * cell_width, cell_height / 2 + j * cell_height), Vector2(cell_width, cell_height))
			cell.connect("clicked", self, "_on_Cell_clicked")
			add_child(cell)
			map[i].append(cell)
			user_map[i].append(cell.alive)

func _process(delta):
	if Input.is_action_just_pressed("ui_left") and alive_count == alive_max_count:
		$StepTimer.start()
		
func _on_StepTimer_timeout():
	step()
	step += 1
	if step >= step_count:
		$StepTimer.stop()
		step = 0
		reset_map()

func _on_Cell_clicked(coord_x, coord_y):
	var cell = map[coord_x][coord_y]
	if not cell.alive and alive_count < alive_max_count:
		alive_count += 1
		cell.set_alive(true)
	elif cell.alive:
		alive_count -= 1
		cell.set_alive(false)
	user_map[coord_x][coord_y] = cell.alive

func step():
	var new_statuses = []
	for i in range(map.size()):
		new_statuses.append([])
		for j in range(map[i].size()):
			var alive = map[i][j].alive
			var alive_around_count = alive_around_count(i, j)
			new_statuses[i].append((alive and alive_around_count in survive_condition) or (not alive and alive_around_count in born_condition))
	
	for i in range(new_statuses.size()):
		for j in range(new_statuses[i].size()):
			map[i][j].set_alive(new_statuses[i][j])	

func reset_map():
	for i in range(map.size()):
		for j in range(map[i].size()):
			map[i][j].set_alive(user_map[i][j])	
	
func alive_around_count(i, j):
	var inc_i = i + 1 if map.size() > i + 1 else 0
	var inc_j = j + 1 if map[i].size() > j + 1 else 0
	var counter = 0
	if map[i - 1][j].alive:
		counter += 1
	if map[i][j - 1].alive:
		counter += 1
	if map[inc_i][j].alive:
		counter += 1
	if map[i][inc_j].alive:
		counter += 1
	if map[i - 1][j - 1].alive:
		counter += 1
	if map[inc_i][inc_j].alive:
		counter += 1
	if map[i - 1][inc_j].alive:
		counter += 1
	if map[inc_i][j - 1].alive:
		counter += 1
	return counter
