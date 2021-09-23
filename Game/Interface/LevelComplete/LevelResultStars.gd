extends HBoxContainer


export (NodePath) onready var _first_star = get_node(_first_star) as NinePatchRect
export (NodePath) onready var _second_star = get_node(_second_star) as NinePatchRect
export (NodePath) onready var _third_star = get_node(_third_star) as NinePatchRect
export (NodePath) onready var _timer = get_node(_timer) as Timer


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
		_first_star.show()
		_timer.start()
		yield(_timer, "timeout")
	if stars_count >= 2:
		_second_star.show()
		_timer.start()
		yield(_timer, "timeout")
	if stars_count >= 3:
		_third_star.show()


func _on_level_change_request(_initial: bool):
	_first_star.hide()
	_second_star.hide()
	_third_star.hide()
