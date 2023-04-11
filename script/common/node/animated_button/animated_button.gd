class_name AnimatedButton
extends TextureButton


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)


func _on_button_down() -> void:
	_animation_player.play("down")


func _on_button_up() -> void:
	_animation_player.play("up")
