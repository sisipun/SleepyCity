class_name Star
extends NinePatchRect


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)


func _ready() -> void:
	randomize()
	var animation_offset: float = randf_range(0.0, _animation_player.get_animation("rotation").length)
	_animation_player.play("rotation")
	_animation_player.seek(animation_offset, true)
