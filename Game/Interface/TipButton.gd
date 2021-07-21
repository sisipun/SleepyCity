extends TextureButton


class_name TipButton


func _ready():
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_pressed():
	EventStorage.emit_signal("decrement_tip")


func _on_game_updated(game: GameInfo):
	if game.tips_count <= 0:
		disabled = true
