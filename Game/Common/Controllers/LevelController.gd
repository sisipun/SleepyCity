extends Node


signal level_complete(level, step_count, earned_bonuses)


func get_number() -> int:
	return GameStorage.game.level_number


func get_progress() -> int:
	return calculate_progress(get_number())


func calculate_progress(level_number: int):
	return int(floor(fmod(sqrt(level_number), 1) * 100))


func get_current() -> LevelInfo:
	if GameStorage.game.level != null:
		return GameStorage.game.level
	
	GameStorage.game.level = generate_level()
	GameStorage.save()
	return GameStorage.game.level


func complete_current(step_count: int, took_tip: bool) -> void:
	var completed: LevelInfo = GameStorage.game.level
	var earned_bonuses: int = 1 if calculate_progress(get_number() + 1) == 0 else 0
	
	GameStorage.game.level_number += 1
	GameStorage.game.level = generate_level()
	if not took_tip and step_count <= len(completed.solution):
		earned_bonuses += min(max(completed.width / 3, 1), 3)
		GameStorage.game.tips_count += earned_bonuses
	
	GameStorage.save()
	emit_signal("level_complete", completed, step_count, earned_bonuses)


func generate_level() -> LevelInfo:
	return GameStorage.game.preset_levels[get_number()] if GameStorage.game.preset_levels.has(get_number()) else LevelGenerator.generate_level(get_number(), LevelInfo.LevelType.DARK)
