extends AnimatedButton


class_name TipButton


@export (NodePath) onready var _count_label = get_node(_count_label) as Label


func _ready() -> void:
	EventStorage.connect("game_updated", Callable(self, "_on_game_updated"))


func _on_pressed() -> void:
	EventStorage.emit_signal("decrement_tip_request")


func _on_game_updated(game: GameInfo):
	_count_label.text = str(game.tips_count)
	if game.tips_count <= 0:
		disabled = true
	else:
		disabled = false
