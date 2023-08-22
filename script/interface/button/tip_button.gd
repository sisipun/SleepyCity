class_name TipButton
extends AnimationButton


@export_node_path("Label") var _count_label_path: NodePath

@onready var _count_label: Label = get_node(_count_label_path)


func _ready() -> void:
	EventStorage.game_updated.connect(_on_game_updated)


func _on_pressed() -> void:
	EventStorage.emit_signal("decrement_tip_request")


func _on_game_updated(game: GameInfo) -> void:
	_count_label.text = str(game.tips_count)
	if game.tips_count <= 0:
		disabled = true
	else:
		disabled = false
