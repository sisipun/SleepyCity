class_name TipController
extends Node


func _ready() -> void:
	EventStorage.decrement_tip.connect(_on_decrement_tip)
	EventStorage.increment_tip.connect(_on_increment_tip)


func _on_decrement_tip() -> void:
	if GameStorage.game.tips_count > 0:
		GameStorage.game.tips_count -= 1
		EventStorage.emit_signal("game_updated", GameStorage.game)


func _on_increment_tip() -> void:
	GameStorage.game.tips_count += 1
	EventStorage.emit_signal("game_updated", GameStorage.game)
