extends Node2D


signal level_complete(step_count, tip_count, reset_count)
signal tip(tip_count)
signal step(step_count)
signal reset(reset_count)


var _level: Game.LevelInfo = Game.get_current_level()
var _completed: bool = false
var _map: Array = []
var _last_tip: int = 0
var _step_count: int = 0
var _reset_count: int = 0
var _tip_count: int = 0
var _cell_margin: float = 1.2


func _ready() -> void:
	var cell_scene: = load("res://scenes/level/Cell.tscn")
	var screen_size: = get_viewport_rect().size
	var cell_width: = (screen_size.x - 2 * position.x) / (_cell_margin * _level.width)
	var cell_height: = (screen_size.y - 2 * position.y) / (_cell_margin * _level.height)
	for i in range(_level.width):
		_map.append([])
		for j in range(_level.height):
			var cell: Cell = cell_scene.instance().init(
				i,
				j,
				Vector2(
					(_cell_margin / 2) * cell_width + i * _cell_margin * cell_width, 
					(_cell_margin / 2) * cell_height + j * _cell_margin * cell_height
				), 
				Vector2(
					cell_width, 
					cell_height
				),
				Vector2(i, j) in _level.initial
			)
			_map[i].append(cell)
			if Vector2(i, j) in _level.targets:
				cell.play_target_effect()
			cell.connect("clicked", self, "_on_cell_clicked")
			add_child(cell)


func _on_cell_clicked(cell: Cell) -> void:
	if _completed:
		return
	
	var coordinates = cell.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	var inc_i: int = i + 1 if _map.size() > i + 1 else 0
	var inc_j: int = j + 1 if _map[i].size() > j + 1 else 0
	
	_map[i][j].set_alive(not _map[i][j].is_alive())
	_map[i - 1][j].set_alive(not _map[i - 1][j].is_alive())
	_map[i][j - 1].set_alive(not _map[i][j - 1].is_alive())
	_map[inc_i][j].set_alive(not _map[inc_i][j].is_alive())
	_map[i][inc_j].set_alive(not _map[i][inc_j].is_alive())
	
	_step_count += 1
	emit_signal("step", _step_count)
	
	if is_target_complete():
		_completed = true
		$Sound/LevelCompleteSound.play()
		Game.completeCurrentLevel(_step_count, _reset_count, _tip_count)
		emit_signal("level_complete", _reset_count)
	else: 
		$Sound/CellSound.play()


func _on_tip_pressed() -> void:
	_last_tip = _last_tip + 1 if _last_tip + 1 < _level.solution.size() else 0
	var last_tip_position: Vector2 = _level.solution[_last_tip]
	var cell: Cell = _map[last_tip_position.x][last_tip_position.y]
	if cell.play_tip_effect():
		_tip_count += 1
		Game.decriment_tip()
		emit_signal("tip", _tip_count)


func _on_reset_pressed() -> void:
	_step_count = 0
	_reset_count += 1
	emit_signal("reset", _reset_count)
	for i in range(_map.size()):
		for j in range(_map[i].size()):
			_map[i][j].set_alive(Vector2(i, j) in _level.initial)


func _on_back_pressed() -> void:
	get_tree().change_scene("res://scenes/menu/ChooseLevel.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene("res://scenes/menu/ChooseLevel.tscn")


func _on_next_level_pressed() -> void:
	get_tree().change_scene("res://scenes/level/Level.tscn")


func is_target_complete() -> bool:
	for target in _level.targets:
		if not _map[target.x][target.y].is_alive():
			return false
	
	for i in len(_map):
		for j in len(_map[i]):
			var targets_contains: bool = Vector2(i, j) in _level.targets
			if _map[i][j].is_alive() and not targets_contains:
				return false
			elif not _map[i][j].is_alive() and targets_contains:
				return false
	
	return true
