extends Node2D


signal step(step_count)
signal completed(steps_count, took_tip)


export (float) var cell_margin: = 10


var _level: LevelMap
var _cells: Array
var _last_tip: = 0
var _took_tip: = false


func set_level(info: Storage.LevelInfo):
	_level = LevelMap.new(info)
	
	var cell_scene: = load("res://Game/Level/Cell.tscn")
	var screen_size: = get_viewport_rect().size
	var original_game_area_width: = screen_size.x - 2 * position.x
	var original_game_area_height: = screen_size.y - 2 * position.y
	var original_cells_width: = original_game_area_width - cell_margin * (_level.width() + 1)
	var original_cells_height: = original_game_area_height - cell_margin * (_level.height() + 1)
	var cell_size: = min(original_cells_width / _level.width(), original_cells_height / _level.height())
	var cells_width: = cell_size * _level.width()
	var cells_height: = cell_size * _level.height()
	var game_area_width: = cells_width + cell_margin * (_level.width() + 1)
	var game_area_height: = cells_height + cell_margin * (_level.height() + 1)
	
	position.x += (original_game_area_width - game_area_width) / 2
	position.y += (original_game_area_height - game_area_height) / 2
	
	var background_size: Vector2 = $BackgroundLayer/Background.get_rect().size
	$BackgroundLayer/Background.set_position(Vector2(
		position.x + game_area_width / 2, 
		position.y + game_area_height / 2
	))
	$BackgroundLayer/Background.scale = Vector2(
		game_area_width / background_size.x, 
		game_area_height / background_size.y
	)

	for i in range(_level.width()):
		_cells.append([])
		for j in range(_level.height()):
			var cell: Cell = cell_scene.instance().init(
				i,
				j,
				Vector2(
					cell_margin + (cell_size / 2) + i * (cell_margin + cell_size), 
					cell_margin + (cell_size / 2) + j * (cell_margin + cell_size)
				), 
				Vector2(
					cell_size, 
					cell_size
				),
				false
			)
			_cells[i].append(cell)
			if _level.is_target(i, j):
				cell.play_target_effect()
			cell.connect("clicked", self, "_on_cell_clicked")
			add_child(cell)
	update_cells()


func _on_cell_clicked(cell: Cell) -> void:
	var coordinates = cell.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	
	if _level.step(i, j):
		update_cells()
		$Sound/CellSound.play()
		emit_signal("step", _level.steps_count())
	
	if _level.is_complete():
		$Sound/LevelCompleteSound.play()
		emit_signal("completed", _level.steps_count(), _took_tip)


func _on_tip() -> void:
	var last_tip_position: Vector2 = _level.solution(_last_tip)
	var cell: Cell = _cells[last_tip_position.x][last_tip_position.y]
	if cell.play_tip_effect() and _level.reset():
		update_cells()
		_took_tip = true
		_last_tip = _last_tip + 1 if _last_tip + 1 < _level.solution_size() else 0
		Storage.decriment_tip()


func _on_reset() -> void:
	if _level.reset():
		update_cells()


func _on_step_back() -> void:
	if _level.step_back():
		emit_signal("step", _level.steps_count())
		update_cells()


func update_cells():
	for i in range(_level.width()):
		for j in range(_level.height()):
			_cells[i][j].set_alive(_level.is_alive(i, j))
