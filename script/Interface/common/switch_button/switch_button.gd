class_name SwitchButton
extends AnimationButton


@export var on_normal: Texture2D
@export var on_pressed: Texture2D
@export var checked_disabled: Texture2D
@export var off_normal: Texture2D
@export var off_pressed: Texture2D
@export var unchecked_disabled: Texture2D


var is_on: bool = true


func _ready() -> void:
	texture_normal = on_normal
	texture_pressed = on_pressed
	texture_disabled = checked_disabled


func set_is_on(_is_on: bool) -> void:
	self.is_on = _is_on
	if is_on:
		texture_normal = on_normal
		texture_pressed = on_pressed
		texture_disabled = checked_disabled
	else:
		texture_normal = off_normal
		texture_pressed = off_pressed
		texture_disabled = unchecked_disabled
