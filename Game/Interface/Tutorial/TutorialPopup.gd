extends Popup


class_name TutorialPopup


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	EventStorage.connect("tutorial_open", self, "_on_tutorial_open")


func _on_tutorial_open(play_sound) -> void:
	popup_centered()
	_animation_player.play("popup")


func _on_close() -> void:
	hide()
	EventStorage.emit_signal("tutorial_closed")
