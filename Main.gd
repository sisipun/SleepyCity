extends Node2D

export (PackedScene) var Cell
export var width = 100
export var height = 50

var map = []
var screen_size

func _ready():
	screen_size = get_viewport_rect().size	
	var cell_width = screen_size.x / width
	var cell_height = screen_size.y / height
	for i in range(width):
		map.append([])
		for j in range(height):
			var cell = Cell.instance()
			add_child(cell)
			if randi() % 2:
				cell.set_alive(false)
			cell.set_size(Vector2(cell_width, cell_height))
			cell.position = Vector2(cell_width / 2 + i * cell_width, cell_height / 2 + j * cell_height)
			map[i].append(cell)

func _process(delta):
	if (Input.is_action_just_pressed("ui_left")):
		step()

func step():
	var new_statuses = [] 
	for i in range(map.size()):
		new_statuses.append([])
		for j in range(map[i].size()):
			var alive = map[i][j].alive
			var alive_count = alive_count(i, j)
			new_statuses[i].append((alive && alive_count in [2, 3]) || (!alive && alive_count == 3))
	
	for i in range(new_statuses.size()):
		for j in range(new_statuses[i].size()):
			map[i][j].set_alive(new_statuses[i][j])	
			
func alive_count(i, j):
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