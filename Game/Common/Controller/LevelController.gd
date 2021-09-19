extends Node


export (Resource) var level_resource = level_resource as LevelResource


func _ready() -> void:
	if GameStorage.game.level == null:
		GameStorage.game.level = _generate_level()
		EventStorage.emit_signal("game_updated", GameStorage.game)
	
	EventStorage.connect("level_change_request", self, "_on_level_change_request")
	EventStorage.connect("level_complete_request", self, "_on_level_complete_request")


func _on_level_change_request(initial):
	EventStorage.emit_signal(
		"level_changed",
		initial,
		GameStorage.game.level, 
		level_resource,
		LevelGenerator.calculate_progress(GameStorage.game.level_number)
	)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func _on_level_complete_request() -> void:
	var completed: LevelInfo = GameStorage.game.level
	var completed_number: int = GameStorage.game.level_number
	var previous_progress: int = LevelGenerator.calculate_progress(GameStorage.game.level_number)
	var current_progress: int = LevelGenerator.calculate_progress(GameStorage.game.level_number + 1)
	var earned_bonus: bool = current_progress == 0
	
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
		earned_bonus
	)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func _generate_level() -> LevelInfo:
	if GameStorage.game.preset_levels.has(GameStorage.game.level_number):
		return GameStorage.game.preset_levels[GameStorage.game.level_number]
	
	return LevelGenerator.generate_level(GameStorage.game.level_number)
