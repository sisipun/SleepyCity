class_name GameProgress
extends TextureProgressBar


@export_node_path ("NinePatchRect") var _blub_path: NodePath
@export_node_path ("AnimationPlayer") var _animation_player_path: NodePath

@export_color_no_alpha var _low_energy_color: Color
@export_color_no_alpha var _middle_energy_color: Color
@export_color_no_alpha var _high_energy_color: Color

@export_range(0, 10) var _change_value_duration: float

@export var _blub_off: Texture2D
@export var _blub_on: Texture2D

@onready var _blub: NinePatchRect = get_node(_blub_path)
@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)


func _ready() -> void:
	EventStorage.level_completed.connect(_on_level_completed)


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	previous_progress: int, 
	current_progress: int, 
	_earned_bonus: bool,
	_stars_count: int
) -> void:
	_blub.texture = _blub_off
	_set_value(previous_progress)
	
	var tween: Tween = create_tween()
	tween.tween_method(
		_set_value, 
		value, 
		float(current_progress) if current_progress != 0 else max_value, 
		_change_value_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	await tween.finished
	if current_progress == 0:
		_animation_player.play("turn_light_on")


func _set_value(new_value: float) -> void:
	value = new_value
	tint_progress = get_color()


func get_color() -> Color:
	var double_delta: float = (max_value - value) * 2 / max_value
	if value >= (max_value / 2):
		return lerp(_high_energy_color, _middle_energy_color, double_delta)
	else:
		return lerp(_middle_energy_color, _low_energy_color, double_delta - 1)
