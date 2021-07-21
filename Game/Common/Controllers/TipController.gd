extends Node


func _ready() -> void:
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")


func _on_decrement_tip() -> void:
	GameStorage.game.tips_count -= 1
	EventStorage.emit_signal("game_updated", GameStorage.game)
