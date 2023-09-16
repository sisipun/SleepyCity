class_name LevelCompletePopup
extends Control


@export_node_path("Label") var _level_label_path: NodePath
@export_node_path("NinePatchRect") var _bonus_icon_path: NodePath
@export_node_path("AnimationPlayer") var _animation_player_path: NodePath
@export_node_path("AnimationButton") var _next_level_button_path: NodePath

@onready var _level_label: Label = get_node(_level_label_path)
@onready var _bonus_icon: NinePatchRect = get_node(_bonus_icon_path)
@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)
@onready var _next_level_button: AnimationButton = get_node(_next_level_button_path)


func _ready() -> void:
	EventStorage.level_completed.connect(_on_level_completed)


func _on_level_completed(
	_level: LevelInfo, 
	level_number: int, 
	_previous_progress: int, 
	_current_progress: int, 
	earned_bonus: bool,
	_stars_count: int
) -> void:
	_next_level_button.disabled = false
	
	show()
	EventStorage.emit_signal("popup_open")
	
	_level_label.text = str(level_number)
	if earned_bonus:
		_bonus_icon.show()
	
	_animation_player.play("popup")


func _on_next_pressed() -> void:
	_next_level_button.disabled = true
	hide()
	EventStorage.emit_signal("interstitial_ad_show_request")
	EventStorage.emit_signal("popup_close")
	_bonus_icon.hide()
	EventStorage.emit_signal("level_change_request", false)
