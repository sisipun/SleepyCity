extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect
export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(
	_level: LevelInfo, 
	level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	earned_bonus: bool
) -> void:
	popup_centered()
	
	_level_label.text = str(level_number)
	if earned_bonus:
		_bonus_icon.show()
	
	_animation_player.play("popup")


func _on_next_pressed() -> void:
	hide()
	_bonus_icon.hide()
	EventStorage.emit_signal("level_change_request", false)
