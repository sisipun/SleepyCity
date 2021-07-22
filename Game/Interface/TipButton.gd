extends TextureButton


class_name TipButton


export (NodePath) var _count_path


onready var _count: Label = get_node(_count_path)


func _ready():
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_pressed():
	EventStorage.emit_signal("decrement_tip")


func _on_game_updated(game: GameInfo):
	_count.text = str(game.tips_count)
	if game.tips_count <= 0:
		disabled = true
