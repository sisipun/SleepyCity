extends NinePatchRect


class_name CarouselElement


export (Texture) var enabled
export (Texture) var disabled


func _ready() -> void:
	disable()


func enable() -> void:
	texture = enabled


func disable() -> void:
	texture = disabled
