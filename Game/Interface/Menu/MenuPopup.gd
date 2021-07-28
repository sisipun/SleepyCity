extends Popup


class_name MenuPopup


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	EventStorage.connect("menu_open", self, "_on_menu_open")


func _on_menu_open() -> void:
	popup_centered()
	_animation_player.play("popup")


func _on_close() -> void:
	hide()
	EventStorage.emit_signal("menu_closed")
