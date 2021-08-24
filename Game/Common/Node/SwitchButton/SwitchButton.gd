extends AnimatedButton


class_name SwitchButton


export (Texture) var on_normal
export (Texture) var on_pressed
export (Texture) var on_disabled
export (Texture) var off_normal
export (Texture) var off_pressed
export (Texture) var off_disabled


var is_on = true


func _ready() -> void:
	texture_normal = on_normal
	texture_pressed = on_pressed
	texture_disabled = on_disabled


func set_is_on(_is_on: bool) -> void:
	self.is_on = _is_on
	if is_on:
		texture_normal = on_normal
		texture_pressed = on_pressed
		texture_disabled = on_disabled
	else:
		texture_normal = off_normal
		texture_pressed = off_pressed
		texture_disabled = off_disabled
