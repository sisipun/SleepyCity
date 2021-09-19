extends Popup


class_name TutorialPopup


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer
export (NodePath) onready var _tutorial_image = get_node(_tutorial_image) as NinePatchRect
export (NodePath) onready var _tap = get_node(_tap) as NinePatchRect
export (NodePath) onready var _carousel = get_node(_carousel) as Carousel
export (Array, Resource) var _tutorial_resources


var resource_index: int = 0
var resource_state: bool = false


func _ready() -> void:
	EventStorage.connect("tutorial_open", self, "_on_open")


func _on_open() -> void:
	popup_centered()
	_animation_player.play("popup")
	yield(_animation_player, "animation_finished")
	show_current(true)
	_animation_player.play("tap")


func _on_close() -> void:
	hide()
	resource_index = 0
	resource_state = false
	update_current()
	EventStorage.emit_signal("tutorial_close")


func _on_previous_pressed() -> void:
	resource_index -= 1
	if resource_index < 0:
		resource_index = len(_tutorial_resources) - 1
	
	resource_state = false
	show_current(true)
	EventStorage.emit_signal("tutorial_next")


func _on_next_pressed() -> void:
	resource_index += 1
	if resource_index >= len(_tutorial_resources):
		resource_index = 0
	
	resource_state = false
	show_current(true)
	EventStorage.emit_signal("tutorial_previous")


func _on_change_statue() -> void:
	resource_state = not resource_state
	show_current(false)


func show_current(restart_animation: bool) -> void:
	if restart_animation:
		_animation_player.stop()
	
	update_current()
	_animation_player.play("tap")


func update_current() -> void:
	var current_resource = _tutorial_resources[resource_index]
	_tap.rect_position = Vector2(current_resource.tap_x, current_resource.tap_y)
	_tutorial_image.texture = current_resource.after if resource_state else current_resource.before
	_carousel.set_current(resource_index)


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_on_close()
