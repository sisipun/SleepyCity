extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect
export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer
export (NodePath) onready var _next_level_button = get_node(_next_level_button) as AnimatedButton


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(
	_level: LevelInfo, 
	level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	earned_bonus: bool,
	_stars_count: int
) -> void:
	_next_level_button.disabled = false
	
	popup_centered()
	EventStorage.emit_signal("popup_open")
	
	_level_label.text = str(level_number)
	if earned_bonus:
		_bonus_icon.show()
	
	_animation_player.play("popup")


func _on_next_pressed() -> void:
	_next_level_button.disabled = true
	hide()
	EventStorage.emit_signal("popup_close")
	_bonus_icon.hide()
	EventStorage.emit_signal("level_change_request", false)
