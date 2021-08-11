extends Node


export (Resource) var level_resource = level_resource as LevelResource


func _ready() -> void:
	if GameStorage.game.level == null:
		GameStorage.game.level = _generate_level()
		EventStorage.emit_signal("game_updated", GameStorage.game)
	
	EventStorage.connect("next_level", self, "_on_next_level")
	EventStorage.connect("complete_current_level", self, "_on_complete_current_level")


func _on_next_level():
	EventStorage.emit_signal(
		"level_changed",
		GameStorage.game.level, 
		level_resource,
		LevelGenerator.calculate_progress(GameStorage.game.level_number)
	)
	EventStorage.emit_signal("game_updated", GameStorage.game)


func _on_complete_current_level() -> void:
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
