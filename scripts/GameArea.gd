extends Node2D

class_name GameArea

signal level_complete(step_count, tip_count, reset_count)
signal tip(tip_count)
signal step(step_count)
signal reset(reset_count)

export var margin_horizontal = 50
export var margin_vertical = 100

var level = Game.currentLevel()
var completed = false
var map = []
var last_tip = 0
var step_count = 0
var reset_count = 0
var tip_count = 0

func _ready():
	var cell_scene = load("res://scenes/Cell.tscn")
	var screen_size = get_viewport_rect().size
	var cell_width = (screen_size.x - 2 * margin_horizontal) / level.width
	var cell_height = (screen_size.y - 2 * margin_vertical) / level.height
	for i in range(level.width):
		map.append([])
		for j in range(level.height):
			var cell = cell_scene.instance().init(
				i,
				j,
				Vector2(
					margin_horizontal + cell_width / 2 + i * cell_width, 
					margin_vertical + cell_height / 2 + j * cell_height
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
			cell.connect("clicked", self, "_on_cell_clicked")
			add_child(cell)

func _on_cell_clicked(cell):
	if completed:
		return
	
	var i = cell.coord_x
	var j = cell.coord_y
	var inc_i = i + 1 if map.size() > i + 1 else 0
	var inc_j = j + 1 if map[i].size() > j + 1 else 0
	
	map[i][j].set_alive(not map[i][j].is_alive())
	map[i - 1][j].set_alive(not map[i - 1][j].is_alive())
	map[i][j - 1].set_alive(not map[i][j - 1].is_alive())
	map[inc_i][j].set_alive(not map[inc_i][j].is_alive())
	map[i][inc_j].set_alive(not map[i][inc_j].is_alive())
	
	step_count += 1
	emit_signal("step", step_count)
	
	if is_target_complete():
		completed = true
		$Sound/LevelCompleteSound.play()
		Game.completeCurrentLevel(step_count, reset_count, tip_count)
		emit_signal("level_complete", reset_count)
	else: 
		$Sound/CellSound.play()

func _on_tip_pressed():
	last_tip = last_tip + 1 if last_tip + 1 < level.solution.size() else 0
	var cell = map[level.solution[last_tip].x][level.solution[last_tip].y]
	if cell.play_tip_effect():
		tip_count += 1
		Game.decriment_tip()
		emit_signal("tip", tip_count)

func _on_reset_pressed():
	step_count = 0
	reset_count += 1
	emit_signal("reset", reset_count)
	for i in range(map.size()):
		for j in range(map[i].size()):
			map[i][j].set_alive(Vector2(i, j) in level.initial)

func _on_back_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_menu_pressed():
	get_tree().change_scene("res://scenes/ChooseLevel.tscn")

func _on_next_level_pressed():
	get_tree().change_scene("res://scenes/Level.tscn")
		
func is_target_complete():
	for target in level.targets:
		if not map[target.x][target.y].is_alive():
			return false
	
	for i in len(map):
		for j in len(map[i]):
			var targets_contains = Vector2(i, j) in level.targets
			if map[i][j].is_alive() and not targets_contains:
				return false
			elif not map[i][j].is_alive() and targets_contains:
				return false
	
	return true
