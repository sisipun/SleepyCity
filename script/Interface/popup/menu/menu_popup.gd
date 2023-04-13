class_name MenuPopup
extends Control


@export var _animation_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)


func _ready() -> void:
	EventStorage.menu_open.connect(_on_menu_open)


func _on_menu_open() -> void:
	show()
	EventStorage.emit_signal("popup_open")
	_animation_player.play("popup")


func _on_close() -> void:
	hide()
	EventStorage.emit_signal("popup_close")
	EventStorage.emit_signal("menu_closed")


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_on_close()


func _on_tutorial_pressed() -> void:
	EventStorage.emit_signal("tutorial_open", false)
