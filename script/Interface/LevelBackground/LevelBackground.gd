extends Control


@export (NodePath) onready var _tween = get_node(_tween) as Tween
@export (NodePath) onready var _background_1 = get_node(_background_1) as NinePatchRect
@export (NodePath) onready var _background_2 = get_node(_background_2) as NinePatchRect
@export (float) var offset = 50

func _ready() -> void:
	EventStorage.connect("level_changed", Callable(self, "_on_level_changed"))


func _on_level_changed(
	initial: bool,
	_info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	if initial:
		return
	
	_tween.interpolate_property(
		_background_1, 
		"position", 
		_background_1.position, 
		Vector2(_background_1.position.x + offset, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
	)
	_tween.interpolate_property(
		_background_2, 
		"position", 
		_background_2.position, 
		Vector2(_background_2.position.x + offset, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
	)
	_tween.start()
	await _tween.tween_all_completed
	
	_tween.interpolate_property(
		_background_1, 
		"position", 
		_background_1.position, 
		Vector2(_background_1.position.x + offset, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_background_2, 
		"position", 
		_background_2.position, 
		Vector2(_background_2.position.x + offset, position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_OUT
	)
	_tween.start()
	await _tween.tween_all_completed
	
	var end_screen = position.x + size.x
	if _background_1.position.x >= end_screen:
		_background_1.position.x = _background_2.position.x - _background_1.size.x
	elif _background_2.position.x >= end_screen:
		_background_2.position.x = _background_1.position.x - _background_2.size.x
