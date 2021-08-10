extends Node


signal game_updated(game)
signal game_saved(game)

signal next_level

signal level_complete(steps_count, took_tip)
signal level_completed(level, level_number, step_count, stars_count, earned_bonus)
signal level_changed(level, level_resource, progress)

signal sound_switch
signal music_switch

signal step(step_count)
signal decrement_tip
signal step_back
signal reset
signal menu_open
signal menu_closed
signal tutorial_open
signal tutorial_closed
