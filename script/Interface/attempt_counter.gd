class_name AttemptCounter
extends Label


var _value: int = 0


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
	_interpolate_value(attempts_left)


func _on_level_changed(
	initial: bool,
	info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	if initial: 
		_value = info.attempt_count
		text = str(_value)
		return
	
	_interpolate_value(info.attempt_count)


func _update_vaue(new_value: int) -> void:
	_set_value(new_value)


func _interpolate_value(destination: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(
		_set_value, 
		_value, 
		destination, 
		abs(destination - _value) / 8.0, 
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _set_value(new_value: int) -> void:
	_value = new_value
	text = str(_value)
