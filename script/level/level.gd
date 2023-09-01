class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _game_area_shape_path: NodePath
@export_node_path("Sprite2D") var _house_path: NodePath
@export_node_path("Sprite2D") var _roof_path: NodePath

@export var _window_scene: PackedScene

@export var window_margin: float = 35

@onready var _game_area_shape: CollisionShape2D = get_node(_game_area_shape_path)
@onready var _house: Sprite2D = get_node(_house_path)
@onready var _roof: Sprite2D = get_node(_roof_path)

var haptic = null

var _level: LevelMap
var _windows: Array = []
var _took_tip: bool = false
var _tutorial: bool = false
var _level_area_y_offset: float


func _ready() -> void:
	_level_area_y_offset = get_viewport_rect().size.y - position.y
	_on_window_size_changed()
	
	get_viewport().size_changed.connect(_on_window_size_changed)
	EventStorage.level_changed.connect(_on_level_changed)
	EventStorage.decrement_tip_request.connect(_on_decrement_tip_request)
	EventStorage.reset_request.connect(_on_reset_request)
	EventStorage.step_back_request.connect(_on_step_back_request)
	
	if Engine.has_singleton("Haptic"):
		haptic = Engine.get_singleton("Haptic")


func _on_window_size_changed() -> void:
	position.x = get_viewport_rect().size.x / 2
	position.y = get_viewport_rect().size.y - _level_area_y_offset


func _on_level_changed(
	initial: bool,
	info: LevelInfo, 
	level_resource: LevelResource, 
	_progress: int
) -> void:
	if initial:
		restart(info, level_resource)
		return
	
	var tween: Tween = create_tween()
	tween.tween_property(
		self, 
		"position", 
		Vector2(-position.x, position.y), 
		1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "restart").bind(info, level_resource))
	tween.parallel().tween_property(
		self, 
		"position", 
		Vector2(position.x, position.y), 
		1.0
	).from(Vector2(position.x + get_viewport_rect().size.x, position.y)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_window_clicked(window: LevelWindow) -> void:
	var coordinates = window.get_coordinates()
	var i: int = coordinates.x
	var j: int = coordinates.y
	
	if _level.make_step(i, j):
		update_windows()
		if GameStorage.game.sound and haptic != null:
			haptic.impact(1)
		EventStorage.emit_signal("steped", _level.step_number(), _level.attempts_left())
	
	if _level.is_complete():
		EventStorage.emit_signal("level_complete_request", _level.step_number(), false)
	elif not _level.has_attempts():
		EventStorage.emit_signal("level_failed")
	elif _tutorial:
		show_tip()


func _on_decrement_tip_request() -> void:
	if show_tip():
		EventStorage.emit_signal("decrement_tip")


func _on_reset_request() -> void:
	if _level.reset():
		update_windows()
		EventStorage.emit_signal("reseted", _level.step_number(), _level.attempts_left())
	if _tutorial:
		show_tip()


func _on_step_back_request() -> void:
	if _level.step_back():
		update_windows()
		EventStorage.emit_signal("steped_back", _level.step_number(), _level.attempts_left())
	if _tutorial:
		show_tip()


func restart(info: LevelInfo, level_resource: LevelResource) -> void:
	clear(info)
	init(info, level_resource)


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



func init(info: LevelInfo, level_resource: LevelResource) -> void:
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


func add_window(i: int) -> void:
	var window: LevelWindow = _window_scene.instantiate()
	add_child(window)
	window.clicked.connect(_on_window_clicked)
	_windows[i].append(window)


func update_windows() -> void:
	for i in range(_level.width()):
		for j in range(_level.height()):
			_windows[i][j].set_on(_level.is_on(i, j))


func show_tip() -> bool:
	if _level.is_complete():
		return false

	var tip: Vector2i = _level.next_step_solution()
	_windows[tip.x][tip.y].play_tip_effect()
	return true
