extends Node


export (Resource) var level_resource = level_resource as LevelResource


func _ready() -> void:
	if GameStorage.game.level == null:
		GameStorage.game.level = _generate_level()
		EventStorage.emit_signal("game_updated", GameStorage.game)
	
	EventStorage.connect("level_change_request", self, "_on_level_change_request")
	EventStorage.connect("level_complete_request", self, "_on_level_complete_request")


func _on_level_change_request(initial: bool):
	EventStorage.emit_signal(
		"level_changed",
		initial,
		GameStorage.game.level, 
		level_resource,
		LevelGenerator.calculate_progress(GameStorage.game.level_number)
	)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func _on_level_complete_request(step_number: int, skipped: bool) -> void:
	var completed: LevelInfo = GameStorage.game.level
	var completed_number: int = GameStorage.game.level_number
	var previous_progress: int = LevelGenerator.calculate_progress(GameStorage.game.level_number)
	var current_progress: int = LevelGenerator.calculate_progress(GameStorage.game.level_number + 1)
	var earned_bonus: bool = current_progress == 0
	
	var perfect_solution_steps = len(completed.solution)
	var border_step = (completed.attempt_count - perfect_solution_steps) / 3.0
	var first_border = perfect_solution_steps + border_step
	var second_border = first_border + border_step
	var stars_count = 1
	if step_number < second_border and not skipped:
		stars_count += 1
	if step_number < first_border and not skipped:
		stars_count += 1
	
	GameStorage.game.stars_count += stars_count
	GameStorage.game.level_number += 1
	GameStorage.game.level = _generate_level()
	
	if earned_bonus:
		EventStorage.emit_signal("increment_tip")
	
	EventStorage.emit_signal(
		"level_completed", 
		completed,
		completed_number,
		previous_progress,
		current_progress,
		earned_bonus,
		stars_count
	)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func _generate_level() -> LevelInfo:
	if GameStorage.game.preset_levels.has(GameStorage.game.level_number):
		return GameStorage.game.preset_levels[GameStorage.game.level_number]
	
	return LevelGenerator.generate_level(GameStorage.game.level_number)
