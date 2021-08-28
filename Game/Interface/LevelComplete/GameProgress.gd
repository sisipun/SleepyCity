extends TextureProgress


export (NodePath) onready var _tween = get_node(_tween) as Tween
export (NodePath) onready var _blub = get_node(_blub) as NinePatchRect
export (Texture) var _blub_off
export (Texture) var _blub_on


func _ready() -> void:
	EventStorage.connect("level_completed", self, "_on_level_completed")
	EventStorage.connect("next_level", self, "_on_next_level")


func _on_level_completed(
	_level: LevelInfo, 
	_level_number: int, 
	previous_progress: int, 
	current_progress: int, 
	_earned_bonus: bool
) -> void:
	_tween.interpolate_property(
		self, 
		"value", 
		previous_progress, 
		current_progress if current_progress != 0 else 100, 
		3.0, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT if current_progress != 0 else Tween.EASE_IN
	)
	_tween.start()
	
	if current_progress == 0:
		yield(_tween, "tween_completed")
		_blub.texture = _blub_on

func _on_next_level(_initial: bool) -> void:
	_blub.texture = _blub_off
