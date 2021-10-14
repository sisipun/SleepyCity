extends Label


class_name AttemptCounter


export (NodePath) onready var _tween = get_node(_tween) as Tween


var _value: int = 0


func _ready() -> void:
	EventStorage.connect("steped", self, "_on_steped")
	EventStorage.connect("steped_back", self, "_on_steped_back")
	EventStorage.connect("reseted", self, "_on_reseted")
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_steped(_step_number: int, attempts_left: int):
	_update_vaue(attempts_left)


func _on_steped_back(_step_number: int, attempts_left: int):
	_update_vaue(attempts_left)


func _on_reseted(_step_number: int, attempts_left: int):
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


func _update_vaue(new_value: int):
	_tween.remove_all()
	_set_value(new_value)


func _interpolate_value(destination: int):
	_tween.interpolate_method(
		self, 
		"_set_value", 
		_value, 
		destination, 
		(destination - _value) / 8.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	_tween.start()


func _set_value(new_value: int):
	_value = new_value
	text = str(_value)
