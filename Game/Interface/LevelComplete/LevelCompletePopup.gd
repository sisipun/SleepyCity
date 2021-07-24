extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _step_label = get_node(_step_label) as Label
export (NodePath) onready var _bonus_label = get_node(_bonus_label) as Label
export (NodePath) onready var _bonus_texture = get_node(_bonus_texture) as TextureRect


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(level: LevelInfo, step_count: int, earned_bonuses: int) -> void:
	popup_centered()
	
	_step_label.text = "%d/%d" % [
		step_count, 
		min(len(level.solution), step_count)
	]
	
	if earned_bonuses > 0:
		_bonus_label.show()
		_bonus_label.text = "x%d" % earned_bonuses
		_bonus_texture.show()
	else:
		_bonus_label.hide()
		_bonus_texture.hide()


func _on_next_pressed() -> void:
	get_tree().reload_current_scene()
