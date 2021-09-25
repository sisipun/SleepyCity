extends HBoxContainer


export (NodePath) onready var _count_label = get_node(_count_label) as Label


func _ready() -> void:
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_game_updated(game: GameInfo):
	_count_label.text = str(game.stars_count)
