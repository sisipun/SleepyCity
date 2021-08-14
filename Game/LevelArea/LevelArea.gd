extends Area2D


class_name LevelArea


export (Resource) var _window_scene
export (NodePath) onready var _shape = get_node(_shape) as CollisionShape2D
export (NodePath) onready var _game_area_shape = get_node(_game_area_shape) as CollisionShape2D
export (NodePath) onready var _background = get_node(_background) as Sprite
export (NodePath) onready var _tween = get_node(_tween) as Tween


export (float) var level_area_margin_left = 20
export (float) var level_area_margin_right = 20
export (float) var level_area_margin_top = 70
export (float) var level_area_margin_bottom = 0
export (float) var window_margin: = 20


var _level: LevelMap
var _windows: Array = []
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
		_level_area_width / (_shape.shape.extents.x * 2), 
		_level_area_height / (_shape.shape.extents.y * 2)
	)


func _on_level_changed(
	info: LevelInfo, 
	level_resource: LevelResource, 
	progress: int
) -> void:
	var initial_x = position.x
	if not _initialized:
		init(info, level_resource)
		return
	
	_tween.interpolate_property(
		self, 
		"position", 
		position, 
		Vector2(-_level_area_width, position.y), 
		0.7, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
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
		0.7, 
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
		EventStorage.emit_signal("step", _level.steps_count())
	
	if _level.is_complete():
		EventStorage.emit_signal("complete_current_level")
	elif _tutorial:
		show_tip()


func _on_decrement_tip() -> void:
	show_tip()


func _on_reset() -> void:
	if _level.reset():
		EventStorage.emit_signal("step", _level.steps_count())
		update_windows()


func _on_step_back() -> void:
	if _level.step_back():
		EventStorage.emit_signal("step", _level.steps_count())
		update_windows()


func clear() -> void:
	_took_tip = false
	_tutorial = false
	_initialized = false

	for i in len(_windows):
		for j in len(_windows[i]):
			remove_child(_windows[i][j])
	_windows = []


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
		_windows.append([])
		for j in range(_level.height()):
			var window_instance: Window = _window_scene.instance()
			add_child(window_instance)
			var window: Window = window_instance.init(
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
			window.connect("clicked", self, "_on_window_clicked")
			_windows[i].append(window)
	update_windows()
	
	var level_background_index = randi() % len(level_resource.house_textures)
	_background.texture = level_resource.house_textures[level_background_index]
	
	if _tutorial:
		EventStorage.emit_signal("tutorial_open", false)
		show_tip()
	
	_initialized = true


func update_windows():
	for i in range(_level.width()):
		for j in range(_level.height()):
			_windows[i][j].set_on(_level.is_on(i, j))


func show_tip():
	var tip: Vector2 = _level.solution()
	var window: Window = _windows[tip.x][tip.y]
	return window.play_tip_effect()
