class_name CarouselElement
extends NinePatchRect


@export var enabled: Texture2D
@export var disabled: Texture2D


func _ready() -> void:
	disable()


func enable() -> void:
	texture = enabled


func disable() -> void:
	texture = disabled
