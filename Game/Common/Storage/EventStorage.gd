extends Node


signal game_updated(game)
signal game_saved(game)

signal next_level(initial)
signal complete_current_level

signal level_completed(level, level_number, previous_progress, current_progress, earned_bonus)
signal level_changed(initial, level, level_resource, progress)

signal sound_switch
signal music_switch

signal step(step_count)
signal decrement_tip
signal increment_tip
signal step_back
signal reset
signal menu_open
signal menu_closed
signal tutorial_open
signal tutorial_closed
