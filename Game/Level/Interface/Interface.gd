extends Control

signal reset
signal tip
signal back_to_menu
signal next

func _ready() -> void:
	$Top/TopLabels/StepLabel.text = "0"
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()


func _on_step(step_count: int) -> void:
	$Top/TopLabels/StepLabel.text = "%d" % step_count


func _on_level_complete(reset_count: int) -> void:
	$LevelCompletePopup.popup_centered()
	$Bottom/BottomButtons/ResetButton.disabled = true
	$Bottom/BottomButtons/TipButton.disabled = true


func _on_menu_pressed() -> void:
	emit_signal("back_to_menu")


func _on_next_pressed() -> void:
	emit_signal("next")


func _on_tip_pressed() -> void:
	emit_signal("tip")
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()	


func _on_reset_pressed() -> void:
	emit_signal("reset")
	$Top/TopLabels/StepLabel.text = "0"


func _on_back_pressed() -> void:
	emit_signal("back_to_menu")
