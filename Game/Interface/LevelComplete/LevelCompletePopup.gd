extends Popup


class_name LevelCompletePopup


export (NodePath) var _step_label_path
export (NodePath) var _bonus_label_path
export (NodePath) var _bonus_texture_path


onready var _step_label: Label = get_node(_step_label_path)
onready var _bonus_label: Label = get_node(_bonus_label_path)
onready var _bonus_texture: TextureRect = get_node(_bonus_texture_path)


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
