extends HBoxContainer


export (NodePath) onready var _first_star = get_node(_first_star) as NinePatchRect
export (NodePath) onready var _second_star = get_node(_second_star) as NinePatchRect
export (NodePath) onready var _third_star = get_node(_third_star) as NinePatchRect
export (NodePath) onready var _timer = get_node(_timer) as Timer
export (NodePath) onready var _tween = get_node(_tween) as Tween


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")
	EventStorage.connect("level_change_request", self, "_on_level_change_request")


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	_earned_bonus: bool,
	stars_count: int
) -> void:
	if stars_count >= 1:
		_interpolate_scale(_first_star)
		yield(_tween, "tween_completed")
	if stars_count >= 2:
		_interpolate_scale(_second_star)
		yield(_tween, "tween_completed")
	if stars_count >= 3:
		_interpolate_scale(_third_star)
		yield(_tween, "tween_completed")


func _on_level_change_request(_initial: bool) -> void:
	_tween.stop_all()	
	_first_star.modulate = Color(1, 1, 1, 0)
	_second_star.modulate = Color(1, 1, 1, 0)
	_third_star.modulate = Color(1, 1, 1, 0)


func _interpolate_scale(star: NinePatchRect) -> void:
	_tween.interpolate_property(
		star, 
		"modulate",
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		0.7, 
		Tween.TRANS_CIRC, 
		Tween.EASE_IN
	)
	_tween.start()
