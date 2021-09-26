extends Popup


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	EventStorage.connect("level_failed", self, "_on_level_failed")


func _on_level_failed() -> void:
	popup_centered()
	EventStorage.emit_signal("popup_open")
	_animation_player.play("popup")


func _on_reset_pressed() -> void:
	hide()
	EventStorage.emit_signal("popup_close")
	EventStorage.emit_signal("reset_request")
