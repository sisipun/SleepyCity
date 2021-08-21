extends HBoxContainer


class_name Carousel


export (Resource) var _element_scene = _element_scene as CarouselElement
export (int) var element_count


var elements = []


func _ready() -> void:
	for i in range(element_count):
		var element = _element_scene.instance()
		elements.push_back(element)
		add_child(element)
	set_current(0)


func set_current(element_number: int) -> void:
	if element_number >= element_count:
		return
	
	for i in range(element_count):
		if element_number == i:
			elements[i].enable()
		else:
			elements[i].disable()
