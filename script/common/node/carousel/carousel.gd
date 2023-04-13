class_name Carousel
extends HBoxContainer


@export var _element_scene: PackedScene
@export var _element_count: int

var elements = []


func _ready() -> void:
	for _i in range(_element_count):
		var element = _element_scene.instantiate()
		elements.push_back(element)
		add_child(element)
	set_current(0)


func set_current(element_number: int) -> void:
	if element_number >= _element_count:
		return
	
	for i in range(_element_count):
		if element_number == i:
			elements[i].enable()
		else:
			elements[i].disable()
