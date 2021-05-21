extends Node2D


signal step(step_count)


var _level: Game.LevelInfo = Game.get_current_level()
var _completed: bool = false
var _map: Array = []
var _steps: Array = []
var _last_tip: int = 0
var _cell_margin: float = 10


func _ready() -> void:
	var cell_scene: = load("res://Game/Level/GameArea/Cell.tscn")
	
	var screen_size: = get_viewport_rect().size
	var game_area_width: = screen_size.x - 2 * position.x
	var cells_width: = game_area_width - _cell_margin * (_level.width + 1)
	var cell_size: = cells_width / _level.width
	var cells_height: = cell_size * _level.height
	var game_area_height: = cells_height + _cell_margin * (_level.height + 1)
	
	var background_size: Vector2 = $BackgroundLayer/Background.get_rect().size
	$BackgroundLayer/Background.set_position(Vector2(
		position.x + game_area_width / 2, 
		position.y + game_area_height / 2
	))
	$BackgroundLayer/Background.scale = Vector2(
		game_area_width / background_size.x, 
		game_area_height / background_size.y
	)

	for i in range(_level.width):
		_map.append([])
		for j in range(_level.height):
			var cell: Cell = cell_scene.instance().init(
				i,
				j,
				Vector2(
					_cell_margin + (cell_size / 2) + i * (_cell_margin + cell_size), 
					_cell_margin + (cell_size / 2) + j * (_cell_margin + cell_size)
				), 
				Vector2(
					cell_size, 
					cell_size
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
	
	_steps.append(Vector2(i, j))	
	make_step(i, j)
	emit_signal("step", len(_steps))
	
	if is_target_complete():
		_completed = true
		$Sound/LevelCompleteSound.play()
		Game.completeCurrentLevel(len(_steps))
	else: 
		$Sound/CellSound.play()


func _on_tip() -> void:
	_last_tip = _last_tip + 1 if _last_tip + 1 < _level.solution.size() else 0
	var last_tip_position: Vector2 = _level.solution[_last_tip]
	var cell: Cell = _map[last_tip_position.x][last_tip_position.y]
	if cell.play_tip_effect():
		Game.decriment_tip()


func _on_reset() -> void:
	_steps = []
	for i in range(_map.size()):
		for j in range(_map[i].size()):
			_map[i][j].set_alive(Vector2(i, j) in _level.initial)


func _on_step_back() -> void:
	if not _steps:
		return
	
	var step: Vector2 = _steps.pop_back()
	make_step(step.x, step.y)
	emit_signal("step", len(_steps))


func _on_back_to_menu() -> void:
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")


func _on_next() -> void:
	get_tree().change_scene("res://Game/Level/Level.tscn")


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
	

func make_step(i, j):
	var inc_i: int = i + 1 if _map.size() > i + 1 else 0
	var inc_j: int = j + 1 if _map[i].size() > j + 1 else 0
	
	_map[i][j].set_alive(not _map[i][j].is_alive())
	_map[i - 1][j].set_alive(not _map[i - 1][j].is_alive())
	_map[i][j - 1].set_alive(not _map[i][j - 1].is_alive())
	_map[inc_i][j].set_alive(not _map[inc_i][j].is_alive())
	_map[i][inc_j].set_alive(not _map[i][inc_j].is_alive())
