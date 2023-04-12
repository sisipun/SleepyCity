class_name LevelBackground
extends Control


@export_node_path("NinePatchRect") var _background_1_path: NodePath
@export_node_path("NinePatchRect") var _background_2_path: NodePath

@export var offset: float = 50

@onready var _tween: Tween = create_tween()
@onready var _background_1: NinePatchRect = get_node(_background_1_path)
@onready var _background_2: NinePatchRect = get_node(_background_2_path) 

func _ready() -> void:
	EventStorage.level_changed.connect(_on_level_changed)


func _on_level_changed(
	initial: bool,
	_info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	if initial:
		return
	
	_tween.tween_property(
		_background_1, 
		"position",
		Vector2(_background_1.position.x + offset, position.y), 
		1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(
		_background_2, 
		"position", 
		Vector2(_background_2.position.x + offset, position.y), 
		1.0, 
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await _tween.tween_all_completed
	
	_tween.tween_property(
		_background_1, 
		"position", 
		Vector2(_background_1.position.x + offset, position.y), 
		1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(
		_background_2, 
		"position", 
		Vector2(_background_2.position.x + offset, position.y), 
		1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await _tween.tween_all_completed
	
	var end_screen: float = position.x + size.x
	if _background_1.position.x >= end_screen:
		_background_1.position.x = _background_2.position.x - _background_1.size.x
	elif _background_2.position.x >= end_screen:
		_background_2.position.x = _background_1.position.x - _background_2.size.x
