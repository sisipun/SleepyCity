extends AnimatedButton


class_name TipButton


export (NodePath) onready var _count_label = get_node(_count_label) as Label


func _ready():
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_pressed():
	EventStorage.emit_signal("decrement_tip")


func _on_game_updated(game: GameInfo):
	_count_label.text = str(game.tips_count)
	if game.tips_count <= 0:
		disabled = true
