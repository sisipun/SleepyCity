class_name StarsCount
extends HBoxContainer


@export_node_path("Label") var _count_label_path: NodePath

@onready var _count_label: Label = get_node(_count_label_path)


func _ready() -> void:
	EventStorage.connect("game_updated", Callable(self, "_on_game_updated"))


func _on_game_updated(game: GameInfo) -> void:
	_count_label.text = str(game.stars_count)
