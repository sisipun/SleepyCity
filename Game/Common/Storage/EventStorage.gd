extends Node

# GAME STATE
signal game_updated(game)
signal game_saved(game)

# LEVEL STATE
signal level_complete_request
signal level_change_request(initial)

signal level_completed(level, level_number, previous_progress, current_progress, earned_bonus)
signal level_changed(initial, level, level_resource, progress)
signal level_failed

# SOUND
signal sound_switch
signal music_switch

# MENU
signal menu_open
signal menu_closed
signal tutorial_open
signal tutorial_closed
signal tutorial_next
signal tutorial_previous

signal steped(step_number, attempts_left)
signal step_back_request
signal steped_back(step_number, attempts_left)
signal reset_request
signal reseted(step_number, attempts_left)

# TIP STATE
signal decrement_tip
signal increment_tip
