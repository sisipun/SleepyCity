class_name AnimationButton
extends TextureButton


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)
var haptic = null

func _ready() -> void:
	if Engine.has_singleton("Haptic"):
		haptic = Engine.get_singleton("Haptic")

func _on_button_down() -> void:
	if GameStorage.game.sound and haptic != null:
		haptic.selection()
	_animation_player.play("down")


func _on_button_up() -> void:
	_animation_player.play("up")
