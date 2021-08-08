extends Area2D


class_name LevelArea


export (Resource) var _cell_scene
export (NodePath) onready var _level_area = get_node(_level_area) as CollisionShape2D
export (NodePath) onready var _game_area = get_node(_game_area) as CollisionShape2D
export (NodePath) onready var _background = get_node(_background) as Sprite
export (NodePath) onready var _tween = get_node(_tween) as Tween


export (float) var level_area_margin_left = 20
export (float) var level_area_margin_right = 20
export (float) var level_area_margin_top = 70
export (float) var level_area_margin_bottom = 0
export (float) var cell_margin: = 20


var _level: LevelMap
var _cells: Array = []
var _took_tip: bool = false
var _tutorial: bool = false
var _level_area_width: float
var _level_area_height: float
var _initialized: bool = false


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")
	EventStorage.connect("reset", self, "_on_reset")
	EventStorage.connect("step_back", self, "_on_step_back")
	
	var screen_size: = get_viewport_rect().size
	_level_area_width = screen_size.x - (level_area_margin_left + level_area_margin_right)
	_level_area_height = screen_size.y - (level_area_margin_top + level_area_margin_bottom)
	
	position.x = level_area_margin_left + _level_area_width / 2
	position.y = level_area_margin_top + _level_area_height / 2
	scale = Vector2(
		_level_area_width / (_level_area.shape.extents.x * 2), 
		_level_area_height / (_level_area.shape.extents.y * 2)
	)


func _on_level_changed(info: LevelInfo, level_resource: LevelResource, progress: int) -> void:
	var initial_x = position.x
	if not _initialized:
		init(info, level_resource)
		return
	
	_tween.interpolate_property(
		self, 
		"position", 
		position, 
		Vector2(-_level_area_width, position.y), 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	_tween.start()
	yield(_tween, "tween_completed")
	
	clear()
	init(info, level_resource)
	
	_tween.interpolate_property(
		self, 
		"position", 
		Vector2(get_viewport_rect().size.x + initial_x, position.y), 
		Vector2(initial_x, position.y), 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	_tween.start()


func _on_cell_clicked(cell: Cell) -> void:
	var coordinates = cell.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	
	if _level.step(i, j):
		update_cells()
		EventStorage.emit_signal("step", _level.steps_count())
	
	if _level.is_complete():
		EventStorage.emit_signal("level_complete", _level.steps_count(), _took_tip)
	elif _tutorial:
		show_tip()


func _on_decrement_tip() -> void:
	show_tip()
	_took_tip = true


func _on_reset() -> void:
	if _level.reset():
		EventStorage.emit_signal("step", _level.steps_count())
		update_cells()


func _on_step_back() -> void:
	if _level.step_back():
		EventStorage.emit_signal("step", _level.steps_count())
		update_cells()


func clear() -> void:
	_took_tip = false
	_tutorial = false
	_initialized = false

	for i in len(_cells):
		for j in len(_cells[i]):
			remove_child(_cells[i][j])
	_cells = []


func init(info: LevelInfo, level_resource: LevelResource):
	_level = LevelMap.new(info)
	_tutorial = info.tutorial
	
	var game_area_width: float = _game_area.shape.b.x - _game_area.shape.a.x
	var game_area_height: float = _game_area.shape.b.y - _game_area.shape.a.y
	var cells_width: float = (game_area_width - cell_margin * (_level.width() + 1)) / _level.width()
	var cells_height: float = (game_area_height - cell_margin * (_level.height() + 1)) / _level.height()
	for i in range(_level.width()):
		_cells.append([])
		for j in range(_level.height()):
			var cell_instance: Cell = _cell_scene.instance()
			add_child(cell_instance)
			var cell: Cell = cell_instance.init(
				i,
				j,
				Vector2(
					_game_area.shape.a.x + cell_margin + (cells_width / 2) + i * (cell_margin + cells_width), 
					_game_area.shape.a.y + cell_margin + (cells_height / 2) + j * (cell_margin + cells_height)
				), 
				Vector2(
					cells_width, 
					cells_height
				),
				false,
				_level.is_target(i, j),
				level_resource
			)
			cell.connect("clicked", self, "_on_cell_clicked")
			_cells[i].append(cell)
	update_cells()
	
	if _tutorial:
		show_tip()
	
	_initialized = true


func update_cells():
	for i in range(_level.width()):
		for j in range(_level.height()):
			_cells[i][j].set_alive(_level.is_alive(i, j))


func show_tip():
	var tip: Vector2 = _level.solution()
	var cell: Cell = _cells[tip.x][tip.y]
	return cell.play_tip_effect()
