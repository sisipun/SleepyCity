extends Popup


class_name MenuPopup


@export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	EventStorage.connect("menu_open", Callable(self, "_on_menu_open"))


func _on_menu_open() -> void:
	popup_centered()
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
