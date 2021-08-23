extends Control


export (NodePath) onready var _tween = get_node(_tween) as Tween
export (NodePath) onready var _background_1 = get_node(_background_1) as NinePatchRect
export (NodePath) onready var _background_2 = get_node(_background_2) as NinePatchRect
export (float) var offset = 50

func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(
	initial: bool,
	info: LevelInfo, 
	level_resource: LevelResource, 
	progress: int
) -> void:
	if initial:
		return
	
	_tween.interpolate_property(
		_background_1, 
		"rect_position", 
		_background_1.rect_position, 
		Vector2(_background_1.rect_position.x + offset, rect_position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
	)
	_tween.interpolate_property(
		_background_2, 
		"rect_position", 
		_background_2.rect_position, 
		Vector2(_background_2.rect_position.x + offset, rect_position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	
	_tween.interpolate_property(
		_background_1, 
		"rect_position", 
		_background_1.rect_position, 
		Vector2(_background_1.rect_position.x + offset, rect_position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_background_2, 
		"rect_position", 
		_background_2.rect_position, 
		Vector2(_background_2.rect_position.x + offset, rect_position.y), 
		1.0, 
		Tween.TRANS_BACK, 
		Tween.EASE_OUT
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	
	var end_screen = rect_position.x + rect_size.x
	if _background_1.rect_position.x >= end_screen:
		_background_1.rect_position.x = _background_2.rect_position.x - _background_1.rect_size.x
	elif _background_2.rect_position.x >= end_screen:
		_background_2.rect_position.x = _background_1.rect_position.x - _background_2.rect_size.x
