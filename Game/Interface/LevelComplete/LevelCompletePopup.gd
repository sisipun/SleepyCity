extends Popup


class_name LevelCompletePopup


export (NodePath) onready var _game_progress = get_node(_game_progress) as TextureProgress
export (NodePath) onready var _level_label = get_node(_level_label) as Label
export (NodePath) onready var _bonus_icon = get_node(_bonus_icon) as NinePatchRect
export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer
export (NodePath) onready var _tween = get_node(_tween) as Tween


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")


func _on_level_completed(
	level: LevelInfo, 
	level_number: int, 
	previous_progress: int, 
	current_progress: int, 
	earned_bonus: bool
) -> void:
	popup_centered()
	
	_level_label.text = str(level_number)
	_game_progress.value = previous_progress
	if earned_bonus:
		_bonus_icon.show()
	
	_animation_player.play("popup")
	
	_tween.interpolate_property(
		_game_progress, 
		"value", 
		previous_progress, 
		current_progress if current_progress != 0 else 100, 
		2.0, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)
	_tween.start()


func _on_next_pressed() -> void:
	hide()
	_bonus_icon.hide()
	EventStorage.emit_signal("next_level")
