extends Node


func _ready() -> void:
	EventStorage.connect("decrement_tip", self, "_on_decrement_tip")
	EventStorage.connect("increment_tip", self, "_on_increment_tip")


func _on_decrement_tip() -> void:
	if GameStorage.game.tips_count > 0:
		GameStorage.game.tips_count -= 1
		EventStorage.emit_signal("game_updated", GameStorage.game)


func _on_increment_tip() -> void:
	GameStorage.game.tips_count += 1
	EventStorage.emit_signal("game_updated", GameStorage.game)
