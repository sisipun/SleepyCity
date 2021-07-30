extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _step_label = get_node(_step_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(level: LevelInfo, level_completed: int, step_count: int, earned_bonuses: int) -> void:
	popup_centered()
	
	_level_label.text = str(level_completed)
	
	_step_label.text = "%d/%d" % [
		step_count, 
		min(len(level.solution), step_count)
	]
	
	if earned_bonuses > 0:
		_bonus_icon.show()
	else:
		_bonus_icon.hide()


func _on_next_pressed() -> void:
	get_tree().reload_current_scene()
