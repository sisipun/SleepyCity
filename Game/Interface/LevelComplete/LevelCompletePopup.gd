extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _step_label = get_node(_step_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(level: LevelInfo, level_number: int, step_count: int, stars_count: int, earned_bonus: bool) -> void:
	popup_centered()
	
	_level_label.text = str(level_number)
	_step_label.text = str(stars_count)
	
	if earned_bonus:
		_bonus_icon.show()
	else:
		_bonus_icon.hide()


func _on_next_pressed() -> void:
	get_tree().reload_current_scene()
