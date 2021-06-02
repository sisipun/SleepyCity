extends Node2D


signal step(step_count)


export (float) var cell_margin: = 10


var _level: Level
var _cells: Array
var _last_tip: = 0
var _took_tip: = false


func _ready() -> void:
	_level = Level.new(Storage.get_current_level()) #Level.new(LevelGenerator.generate(5, 10, 7)) 
	
	var cell_scene: = load("res://Game/Level/GameArea/Cell.tscn")
	var screen_size: = get_viewport_rect().size
	var game_area_width: = screen_size.x - 2 * position.x
	var cells_width: = game_area_width - cell_margin * (_level.width() + 1)
	var cell_size: = cells_width / _level.width()
	var cells_height: = cell_size * _level.height()
	var game_area_height: = cells_height + cell_margin * (_level.height() + 1)
	
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
		emit_signal("step", _level.steps_count())
		$Sound/CellSound.play()
	
	if _level.is_complete():
		$Sound/LevelCompleteSound.play()
		Storage.completeCurrentLevel(_level.steps_count(), _took_tip)


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
