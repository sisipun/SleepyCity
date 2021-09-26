extends Area2D


class_name LevelArea


export (Resource) var _window_scene = _window_scene as Window
export (NodePath) onready var _shape = get_node(_shape) as CollisionShape2D
export (NodePath) onready var _game_area_shape = get_node(_game_area_shape) as CollisionShape2D
export (NodePath) onready var _house = get_node(_house) as Sprite
export (NodePath) onready var _roof = get_node(_roof) as Sprite
export (NodePath) onready var _tween = get_node(_tween) as Tween


export (float) var level_area_margin_left = 20
export (float) var level_area_margin_right = 20
export (float) var level_area_margin_top = 200
export (float) var level_area_margin_bottom = 0
export (float) var window_margin: = 35


var _level: LevelMap
var _windows: Array = []
var _took_tip: bool = false
var _tutorial: bool = false
var _level_area_width: float
var _level_area_height: float


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")
	EventStorage.connect("reset_request", self, "_on_reset_request")
	EventStorage.connect("step_back_request", self, "_on_step_back_request")
	
	var screen_size: = get_viewport_rect().size
	_level_area_width = screen_size.x - (level_area_margin_left + level_area_margin_right)
	_level_area_height = screen_size.y - (level_area_margin_top + level_area_margin_bottom)
	
	position.x = level_area_margin_left + _level_area_width / 2
	position.y = level_area_margin_top + _level_area_height / 2
	scale = Vector2(
		_level_area_width / (_shape.shape.extents.x * 2), 
		_level_area_height / (_shape.shape.extents.y * 2)
	)


func _on_level_changed(
	initial: bool,
	info: LevelInfo, 
	level_resource: LevelResource, 
	_progress: int
) -> void:
	if initial:
		clear(info)
		init(info, level_resource)
		return
	
	var initial_x = position.x
	_tween.interpolate_property(
		self, 
		"position", 
		position, 
		Vector2(-_level_area_width, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
	)
	_tween.start()
	yield(_tween, "tween_completed")
	
	clear(info)
	init(info, level_resource)
	
	_tween.interpolate_property(
		self, 
		"position", 
		Vector2(get_viewport_rect().size.x + initial_x, position.y), 
		Vector2(initial_x, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_OUT
	)
	_tween.start()


func _on_window_clicked(window: Window) -> void:
	var coordinates = window.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	
	if _level.step(i, j):
		update_windows()
		EventStorage.emit_signal("steped", _level.step_number(), _level.attempts_left())
	
	if _level.is_complete():
		EventStorage.emit_signal("level_complete_request", _level.step_number(), false)
	elif not _level.has_attempts():
		EventStorage.emit_signal("level_failed")
	elif _tutorial:
		show_tip()


func _on_decrement_tip() -> void:
	show_tip()


func _on_reset_request() -> void:
	if _level.reset():
		update_windows()
		EventStorage.emit_signal("reseted", _level.step_number(), _level.attempts_left())


func _on_step_back_request() -> void:
	if _level.step_back():
		update_windows()
		EventStorage.emit_signal("steped_back", _level.step_number(), _level.attempts_left())


func clear(info: LevelInfo) -> void:
	_took_tip = false
	_tutorial = false
	
	for window_row in _windows:
		for window in window_row: 
			window.hide()
	
	if info.width == len(_windows) and info.height == len(_windows[0]):
		return
	
	for i in range(info.width):
		if i < len(_windows):
			for _j in range(info.height - len(_windows[i])):
				add_window(i)
		else:
			_windows.append([])
			for _j in range(info.height):
				add_window(i)



func init(info: LevelInfo, level_resource: LevelResource):
	_level = LevelMap.new(info)
	_tutorial = info.tutorial
	
	var game_area_width: float = _game_area_shape.shape.b.x - _game_area_shape.shape.a.x
	var game_area_height: float = _game_area_shape.shape.b.y - _game_area_shape.shape.a.y
	var windows_width: float = (game_area_width - window_margin * (_level.width() + 1)) / _level.width()
	var windows_height: float = (game_area_height - window_margin * (_level.height() + 1)) / _level.height()
	
	var window_sprite_frames_index = randi() % len(level_resource.window_sprite_frames)
	var window_border_sprite_texute_index = randi() % len(level_resource.window_border_sprite_texture)
	var window_sprite_frames = level_resource.window_sprite_frames[window_sprite_frames_index]
	var window_border_sprite_texure = level_resource.window_border_sprite_texture[window_border_sprite_texute_index]
	for i in range(_level.width()):
		for j in range(_level.height()):
			var window = _windows[i][j]
			window.init(
				i,
				j,
				Vector2(
					_game_area_shape.shape.a.x + window_margin + (windows_width / 2) + i * (window_margin + windows_width), 
					_game_area_shape.shape.a.y + window_margin + (windows_height / 2) + j * (window_margin + windows_height)
				), 
				Vector2(
					windows_width, 
					windows_height
				),
				false,
				_level.is_target(i, j),
				window_sprite_frames,
				window_border_sprite_texure
			)
			window.show()
	update_windows()
	
	var house_color_index = randi() % len(level_resource.house_colors)
	_house.modulate = level_resource.house_colors[house_color_index]
	
	var roof_index = randi() % len(level_resource.roof_textures)
	_roof.texture = level_resource.roof_textures[roof_index]
	
	if _tutorial:
		EventStorage.emit_signal("tutorial_open", true)
		show_tip()


func add_window(i: int):
	var window: Window = _window_scene.instance()
	add_child(window)
	window.connect("clicked", self, "_on_window_clicked")
	_windows[i].append(window)


func update_windows():
	for i in range(_level.width()):
		for j in range(_level.height()):
			_windows[i][j].set_on(_level.is_on(i, j))


func show_tip():
	var tip: Vector2 = _level.solution()
	var window: Window = _windows[tip.x][tip.y]
	return window.play_tip_effect()
