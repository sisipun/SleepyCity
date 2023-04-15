class_name GameProgress
extends TextureProgressBar


@export_node_path ("NinePatchRect") var _blub_path: NodePath

@export var _blub_off: Texture2D
@export var _blub_on: Texture2D

@onready var _blub: NinePatchRect = get_node(_blub_path)


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
	
	var tween: Tween = create_tween()
	tween.tween_property(
		self, 
		"value",
		float(current_progress) if current_progress != 0 else 100.0, 
		2.0
	).from(float(previous_progress)).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	await tween.finished
	if current_progress == 0:
		_blub.texture = _blub_on
