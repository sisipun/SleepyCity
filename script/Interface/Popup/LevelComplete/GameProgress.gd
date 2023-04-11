extends TextureProgressBar


@export (NodePath) onready var _tween = get_node(_tween) as Tween
@export (NodePath) onready var _blub = get_node(_blub) as NinePatchRect
@export (Texture2D) var _blub_off
@export (Texture2D) var _blub_on


func _ready() -> void:
	EventStorage.connect("level_completed", Callable(self, "_on_level_completed"))


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	previous_progress: int, 
	current_progress: int, 
	_earned_bonus: bool,
	_stars_count: int
) -> void:
	_blub.texture = _blub_off
	_tween.interpolate_property(
		self, 
		"value", 
		previous_progress, 
		current_progress if current_progress != 0 else 100, 
		2.0,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
	)
	
	_tween.start()
	
	if current_progress == 0:
		await _tween.tween_completed
		_blub.texture = _blub_on
