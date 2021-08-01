extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect
export (Array, NodePath) var _stars


var _star_icons: Array = []

func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")
	for _star_path in _stars:
		_star_icons.push_back(get_node(_star_path) as NinePatchRect)


func _on_level_completed(level: LevelInfo, level_number: int, step_count: int, stars_count: int, earned_bonus: bool) -> void:
	popup_centered()
	
	_level_label.text = str(level_number)
	
	for i in range(stars_count):
		_star_icons[i].show()
	
	if earned_bonus:
		_bonus_icon.show()
	else:
		_bonus_icon.hide()


func _on_next_pressed() -> void:
	get_tree().reload_current_scene()
