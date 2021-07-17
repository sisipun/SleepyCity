extends Area2D


signal step(step_count)
signal completed(steps_count, took_tip)

export (float) var level_area_margin_left = 20
export (float) var level_area_margin_right = 20
export (float) var level_area_margin_top = 30
export (float) var level_area_margin_bottom = 100
export (float) var cell_margin: = 20


var _level: LevelMap
var _cells: Array
var _took_tip: = false
var _tutorial: = false


func init(info: Storage.LevelInfo):
	_level = LevelMap.new(info)
	_tutorial = info.tutorial
	
	 # OS.get_window_safe_area().position.y
	
	var screen_size: = get_viewport_rect().size
	var level_area_width: float = screen_size.x - (level_area_margin_left + level_area_margin_right)
	var level_area_heigth: float = screen_size.y - (level_area_margin_top + level_area_margin_bottom)
	
	var game_area_position_x: float = $GameAreaShape.shape.a.x
	var game_area_position_y: float = $GameAreaShape.shape.a.y
	var game_area_width: float = $GameAreaShape.shape.b.x - $GameAreaShape.shape.a.x
	var game_area_height: float = $GameAreaShape.shape.b.y - $GameAreaShape.shape.a.y
	var cells_width: = (game_area_width - cell_margin * (_level.width() + 1)) / _level.width()
	var cells_height: = (game_area_height - cell_margin * (_level.height() + 1)) / _level.height()
	
	var cell_scene: = load("res://Game/Level/Cell.tscn")
	for i in range(_level.width()):
		_cells.append([])
		for j in range(_level.height()):
			var cell: Cell = cell_scene.instance().init(
				i,
				j,
				Vector2(
					game_area_position_x + cell_margin + (cells_width / 2) + i * (cell_margin + cells_width), 
					game_area_position_y + cell_margin + (cells_height / 2) + j * (cell_margin + cells_height)
				), 
				Vector2(
					cells_width, 
					cells_height
				),
				false
			)
			_cells[i].append(cell)
			if _level.is_target(i, j):
				cell.play_target_effect()
			cell.connect("clicked", self, "_on_cell_clicked")
			add_child(cell)
	update_cells()
	
	scale = Vector2(
		level_area_width / ($LevelAreaShape.shape.extents.x * 2), 
		level_area_heigth / ($LevelAreaShape.shape.extents.y * 2)
	)
	position.x = level_area_margin_left + level_area_width / 2
	position.y = level_area_margin_top + level_area_heigth / 2
	$BackgroundLayer/Background.scale = scale
	$BackgroundLayer/Background.position = position
	
	
	if _tutorial:
		show_tip()


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
	elif _tutorial:
		show_tip()


func _on_tip() -> void:
	if show_tip():
		_took_tip = true
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


func show_tip():
	var tip: Vector2 = _level.solution()
	var cell: Cell = _cells[tip.x][tip.y]
	return cell.play_tip_effect()
