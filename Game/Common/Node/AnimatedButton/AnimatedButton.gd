extends TextureButton


class_name AnimatedButton


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _on_button_down() -> void:
	_animation_player.play("down")


func _on_button_up() -> void:
	_animation_player.play("up")
