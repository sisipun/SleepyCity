class_name AttemptBar
extends TextureProgressBar


@export_node_path("NinePatchRect") var _sign_path: NodePath

@export_color_no_alpha var _low_energy_color: Color
@export_color_no_alpha var _middle_energy_color: Color
@export_color_no_alpha var _high_energy_color: Color

@onready var _sign: NinePatchRect = get_node(_sign_path)


func _ready() -> void:
	EventStorage.steped.connect(_on_steped)
	EventStorage.steped_back.connect(_on_steped_back)
	EventStorage.reseted.connect(_on_reseted)
	EventStorage.level_changed.connect(_on_level_changed)


func _on_steped(_step_number: int, attempts_left: int) -> void:
	_update_vaue(attempts_left)


func _on_steped_back(_step_number: int, attempts_left: int) -> void:
	_update_vaue(attempts_left)


func _on_reseted(_step_number: int, attempts_left: int) -> void:
	_update_vaue(attempts_left)


func _on_level_changed(
	_initial: bool,
	info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	max_value = info.attempt_count
	_set_value(info.attempt_count)


func _update_vaue(new_value: int) -> void:
	_set_value(new_value)


func _interpolate_value(destination: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(
		_set_value, 
		value, 
		destination, 
		abs(destination - value) / 8.0, 
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _set_value(new_value: int) -> void:
	value = new_value
	var color: Color = get_color()
	tint_progress = color
	_sign.modulate = color


func get_color() -> Color:
	var double_delta: float = (max_value - value) * 2 / max_value
	if value >= (max_value / 2):
		return lerp(_high_energy_color, _middle_energy_color, double_delta)
	else:
		return lerp(_middle_energy_color, _low_energy_color, double_delta - 1)
