class_name AttemptBar
extends TextureProgressBar


@export_node_path("NinePatchRect") var _sign_path: NodePath
@export_node_path("AnimationPlayer") var _animation_player_path: NodePath

@export_color_no_alpha var _low_energy_color: Color
@export_color_no_alpha var _middle_energy_color: Color
@export_color_no_alpha var _high_energy_color: Color

@export_range(0, 10) var _change_value_duration: float

@onready var _sign: NinePatchRect = get_node(_sign_path)
@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)

var _tween: Tween
var _attempt_value: int
var _attempt_share: float


func _ready() -> void:
	_attempt_value = 0
	_attempt_share = 0.0
	EventStorage.steped.connect(_on_steped)
	EventStorage.steped_back.connect(_on_steped_back)
	EventStorage.reseted.connect(_on_reseted)
	EventStorage.level_changed.connect(_on_level_changed)


func _on_steped(_step_number: int, attempts_left: int) -> void:
	_interpolate_attempt(attempts_left)


func _on_steped_back(_step_number: int, attempts_left: int) -> void:
	_interpolate_attempt(attempts_left)


func _on_reseted(_step_number: int, attempts_left: int) -> void:
	_interpolate_attempt(attempts_left)


func _on_level_changed(
	_initial: bool,
	info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	_attempt_share = max_value / info.attempt_count
	if _initial:
		_update_attempt(info.attempt_count)
	else:
		_interpolate_attempt(info.attempt_count)


func _update_attempt(attempt: int) -> void:
	_attempt_value = attempt 
	_update_value(_attempt_value * _attempt_share)


func _interpolate_attempt(attempt: int) -> void:
	_attempt_value = attempt
	_interpolate_value(_attempt_value * _attempt_share)


func _update_value(new_value: float) -> void:
	if _tween and _tween.is_running():
		_tween.custom_step(_change_value_duration)
		_tween.stop()
	
	_set_value(new_value)


func _interpolate_value(new_value: float) -> void:
	if _tween and _tween.is_running():
		_tween.custom_step(_change_value_duration)
		_tween.stop()
	
	_tween = create_tween()
	_tween.tween_method(
		_set_value, 
		value, 
		new_value, 
		_change_value_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _set_value(new_value: float) -> void:
	value = new_value
	var color: Color = get_color()
	tint_progress = color
	_sign.modulate = color
	
	if value < (max_value / 3):
		_animation_player.play("shake")
	else:
		_animation_player.stop()


func get_color() -> Color:
	var double_delta: float = (max_value - value) * 2 / max_value
	if value >= (max_value / 2):
		return lerp(_high_energy_color, _middle_energy_color, double_delta)
	else:
		return lerp(_middle_energy_color, _low_energy_color, double_delta - 1)
