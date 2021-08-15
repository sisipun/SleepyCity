extends NinePatchRect


export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready() -> void:
	randomize()
	var animation_offset: float = rand_range(0.0, _animation_player.get_animation("rotation").length)
	_animation_player.play("rotation")
	_animation_player.seek(animation_offset, true)
