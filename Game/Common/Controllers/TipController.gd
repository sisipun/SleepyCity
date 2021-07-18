extends Node


signal decrement(count)


func count() -> int:
	return GameStorage.game.tips_count


func has_any() -> bool:
	return GameStorage.game.tips_count > 0


func decriment() -> void:
	GameStorage.game.tips_count -= 1
	GameStorage.save()
	emit_signal("tip", GameStorage.game.tips_count)
