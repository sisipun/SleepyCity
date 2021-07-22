extends Area2D


class_name LevelArea


export (NodePath) var _level_area_path
export (NodePath) var _game_area_path
export (NodePath) var _background_path
export (NodePath) var _cell_sound_path
export (NodePath) var _level_complete_sound_path
export (float) var level_area_margin_left = 20
export (float) var level_area_margin_right = 20
export (float) var level_area_margin_top = 70
export (float) var level_area_margin_bottom = 0
export (float) var cell_margin: = 20


onready var _level_area: CollisionShape2D = get_node(_level_area_path)
onready var _game_area: CollisionShape2D = get_node(_game_area_path)
onready var _background: Sprite = get_node(_background_path)
onready var _cell_sound: AudioStreamPlayer = get_node(_cell_sound_path)
onready var _level_complete_sound: AudioStreamPlayer = get_node(_level_complete_sound_path)


var _level: LevelMap
var _cells: Array
var _took_tip: = false
var _tutorial: = false


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")
	EventStorage.connect("reset", self, "_on_reset")
	EventStorage.connect("step_back", self, "_on_step_back")


func _on_level_changed(info: LevelInfo, progress: int):
	_level = LevelMap.new(info)
	_tutorial = info.tutorial
	
	var screen_size: = get_viewport_rect().size
	var level_area_width: float = screen_size.x - (level_area_margin_left + level_area_margin_right)
	var level_area_heigth: float = screen_size.y - (level_area_margin_top + level_area_margin_bottom)
	
	var game_area_position_x: float = _game_area.shape.a.x
	var game_area_position_y: float = _game_area.shape.a.y
	var game_area_width: float = _game_area.shape.b.x - _game_area.shape.a.x
	var game_area_height: float = _game_area.shape.b.y - _game_area.shape.a.y
	var cells_width: = (game_area_width - cell_margin * (_level.width() + 1)) / _level.width()
	var cells_height: = (game_area_height - cell_margin * (_level.height() + 1)) / _level.height()
	
	var cell_scene: = load("res://Game/Level/Cell.tscn")
	for i in range(_level.width()):
		_cells.append([])
		for j in range(_level.height()):
			var cell_instance: Cell = cell_scene.instance()
			add_child(cell_instance)
			var cell: Cell = cell_instance.init(
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
				false,
				_level.is_target(i, j)
			)
			cell.connect("clicked", self, "_on_cell_clicked")
			_cells[i].append(cell)
	update_cells()
	
	scale = Vector2(
		level_area_width / (_level_area.shape.extents.x * 2), 
		level_area_heigth / (_level_area.shape.extents.y * 2)
	)
	position.x = level_area_margin_left + level_area_width / 2
	position.y = level_area_margin_top + level_area_heigth / 2
	_background.scale = scale
	_background.position = position
	
	
	if _tutorial:
		show_tip()


func _on_cell_clicked(cell: Cell) -> void:
	var coordinates = cell.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	
	if _level.step(i, j):
		update_cells()
		_cell_sound.play()
		EventStorage.emit_signal("step_count_updated", _level.steps_count())
	
	if _level.is_complete():
		_level_complete_sound.play()
		EventStorage.emit_signal("level_complete", _level.steps_count(), _took_tip)
	elif _tutorial:
		show_tip()


func _on_decrement_tip() -> void:
	show_tip()
	_took_tip = true


func _on_reset() -> void:
	if _level.reset():
		update_cells()


func _on_step_back() -> void:
	if _level.step_back():
		EventStorage.emit_signal("step_count_updated", _level.steps_count())
		update_cells()


func update_cells():
	for i in range(_level.width()):
		for j in range(_level.height()):
			_cells[i][j].set_alive(_level.is_alive(i, j))


func show_tip():
	var tip: Vector2 = _level.solution()
	var cell: Cell = _cells[tip.x][tip.y]
	return cell.play_tip_effect()
