class_name LevelResultStars
extends HBoxContainer


@export_node_path("NinePatchRect") var _first_star_path: NodePath
@export_node_path("NinePatchRect") var _second_star_path: NodePath
@export_node_path("NinePatchRect") var _third_star_path: NodePath

@onready var _first_star: NinePatchRect = get_node(_first_star_path)
@onready var _second_star: NinePatchRect = get_node(_second_star_path)
@onready var _third_star: NinePatchRect = get_node(_third_star_path)


var _tween: Tween = null


func _ready() -> void:
	EventStorage.level_completed.connect(_on_level_completed)
	EventStorage.level_change_request.connect(_on_level_change_request)


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	_earned_bonus: bool,
	stars_count: int
) -> void:
	_tween = create_tween()
	if stars_count >= 1:
		_interpolate_modulate(_tween, _first_star, 0.7)
	if stars_count >= 2:
		_interpolate_modulate(_tween, _second_star, 0.7)
	if stars_count >= 3:
		_interpolate_modulate(_tween, _third_star, 0.7)


func _on_level_change_request(_initial: bool) -> void:
	if _tween:
		_tween.kill()
		_tween = null
	
	_first_star.modulate = Color(1, 1, 1, 0)
	_second_star.modulate = Color(1, 1, 1, 0)
	_third_star.modulate = Color(1, 1, 1, 0)


func _interpolate_modulate(
	tween: Tween, 
	star: NinePatchRect, 
	duration: float
) -> void:
	tween.tween_property(
		star, 
		"modulate",
		Color(1, 1, 1, 1),
		duration
	).from(Color(1, 1, 1, 0)).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
