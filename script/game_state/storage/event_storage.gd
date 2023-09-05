extends Node

# GAME STATE
signal game_updated(game)
signal game_saved(game)

# LEVEL STATE
signal level_complete_request(step_number, skipped)
signal level_change_request(initial)

signal level_completed(level, level_number, previous_progress, current_progress, earned_bonus, stars_count)
signal level_changed(initial, level, level_resource, progress)
signal level_failed

# SOUND
signal sound_switch
signal music_switch

# HAPTIC
signal haptic_selection_request
signal haptic_impact_request(value)

# MENU
signal menu_open
signal menu_closed
signal tutorial_open(initial)
signal tutorial_closed
signal tutorial_next
signal tutorial_previous
signal popup_open
signal popup_close

# USER ACTIONS
signal steped(step_number, attempts_left)
signal step_back_request
signal steped_back(step_number, attempts_left)
signal reset_request
signal reseted(step_number, attempts_left)

# TIP STATE
signal decrement_tip_request
signal decrement_tip
signal increment_tip

# AD
signal ad_initialized

signal banner_ad_load_request

signal interstitial_ad_load_request
signal interstitial_ad_show_request
signal interstitial_ad_closed

signal rewarded_ad_load_request
signal rewarded_ad_loaded
signal rewarded_ad_show_request
signal rewarded_ad_earned
signal rewarded_ad_closed
