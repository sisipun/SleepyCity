extends Node


func _ready() -> void:
	if GameStorage.game.level == null:
		GameStorage.game.level = _generate_level(LevelInfo.LevelType.DARK)
		EventStorage.emit_signal("game_updated", GameStorage.game)
	
	EventStorage.connect("level_loaded", self, "_on_level_loaded")
	EventStorage.connect("level_complete", self, "_on_level_complete")


func _on_level_loaded():
	EventStorage.emit_signal("level_changed", GameStorage.game.level, _calculate_progress(GameStorage.game.level_number))


func _on_level_complete(step_count: int, took_tip: bool) -> void:
	var completed: LevelInfo = GameStorage.game.level
	var progress: int = _calculate_progress(GameStorage.game.level_number + 1)
	var earned_bonuses: int = 0
	
	GameStorage.game.level_number += 1
	GameStorage.game.level = _generate_level(1 - completed.type if progress == 0  else completed.type)
	if not took_tip and step_count <= len(completed.solution):
		earned_bonuses += min(max(completed.width / 3, 1), 3)
		GameStorage.game.tips_count += earned_bonuses
	
	EventStorage.emit_signal("game_updated", GameStorage.game)
	EventStorage.emit_signal("level_completed", completed, step_count, earned_bonuses)


func _generate_level(var levelType: int) -> LevelInfo:
	if GameStorage.game.preset_levels.has(GameStorage.game.level_number):
		return GameStorage.game.preset_levels[GameStorage.game.level_number]
	
	return LevelGenerator.generate_level(GameStorage.game.level_number, levelType)


func _calculate_progress(level_number: int):
	return int(floor(fmod(sqrt(level_number), 1) * 100))
