extends Node


signal game_updated(game)
signal game_saved(game)

signal level_loaded
signal level_complete(steps_count, took_tip)
signal level_completed(level, step_count, earned_bonuses)
signal level_changed(level, progress)

signal sound_switch
signal music_switch

signal step_count_updated(step_count)
signal decrement_tip
signal step_back
signal reset
signal menu_open
