class_name LevelResultStars
extends HBoxContainer


@export_node_path("NinePatchRect") var _first_star_path: NodePath
@export_node_path("NinePatchRect") var _second_star_path: NodePath
@export_node_path("NinePatchRect") var _third_star_path: NodePath
@export_node_path("Timer") var _timer_path: NodePath

@onready var _first_star: NinePatchRect = get_node(_first_star_path)
@onready var _second_star: NinePatchRect = get_node(_second_star_path)
@onready var _third_star: NinePatchRect = get_node(_third_star_path)
@onready var _timer: Timer = get_node(_timer_path)
@onready var _tween: Tween = create_tween()


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
	if stars_count >= 1:
		_interpolate_scale(_first_star, 0.7, 0.0)
	if stars_count >= 2:
		_interpolate_scale(_second_star, 0.7, 0.7)
	if stars_count >= 3:
		_interpolate_scale(_third_star, 0.7, 1.4)


func _on_level_change_request(_initial: bool) -> void:
	_tween.stop()
	_first_star.modulate = Color(1, 1, 1, 0)
	_second_star.modulate = Color(1, 1, 1, 0)
	_third_star.modulate = Color(1, 1, 1, 0)


func _interpolate_scale(star: NinePatchRect, duration: float, delay: float) -> void:
	_tween.tween_property(
		star, 
		"modulate",
		Color(1, 1, 1, 1),
		duration
	).from(Color(1, 1, 1, 0)).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN).set_delay(delay)
