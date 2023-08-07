class_name TutorialPopup
extends Control


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath
@export_node_path("NinePatchRect") var _tutorial_image_path: NodePath
@export_node_path("NinePatchRect") var _tap_path: NodePath
@export_node_path("Carousel") var _carousel_path: NodePath

@export var _tutorial_resources: Array[TutorialResource]

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)
@onready var _tutorial_image: NinePatchRect = get_node(_tutorial_image_path)
@onready var _tap: NinePatchRect = get_node(_tap_path)
@onready var _carousel: Carousel = get_node(_carousel_path)

var resource_index: int = 0
var resource_state: bool = false
var initial: bool = false


func _ready() -> void:
	EventStorage.tutorial_open.connect(_on_open)


func _on_open(_initial: bool) -> void:
	self.initial = _initial
	show()
	EventStorage.emit_signal("popup_open")
	_animation_player.play("popup")
	await _animation_player.animation_finished
	show_current(true)


func _on_close() -> void:
	hide()
	if initial:
		EventStorage.emit_signal("popup_close")
	resource_index = 0
	resource_state = false
	update_current()
	_animation_player.stop(true)
	EventStorage.emit_signal("tutorial_closed")


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
		_animation_player.stop(true)
		_animation_player.play("tap")
	
	update_current()


func update_current() -> void:
	var current_resource = _tutorial_resources[resource_index]
	_tap.position = Vector2i(current_resource.tap_x, current_resource.tap_y)
	_tutorial_image.texture = current_resource.after if resource_state else current_resource.before
	_carousel.set_current(resource_index)


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_on_close()
