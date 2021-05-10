extends CanvasLayer

func _on_state_changed(stage, step_number, step_count, alive_count, alive_max_count, tip_count):
	$TopContainer/TopHorizontalContainer/ActiveCountLabel.text = "Active count %d/%d" % [alive_count, alive_max_count]
	$TopContainer/TopHorizontalContainer/StepNumberLabel.text = "Step: %d/%d" % [step_number, step_count]	
	$TopContainer/TopHorizontalContainer/TopHorizontalButtonsContainer/TipButton.text = "Tip (%d left)" % Game.tip_count()
	$TopContainer/TopHorizontalContainer/TopHorizontalButtonsContainer/TipButton.disabled = stage != GameArea.Stage.USER_INPUT or tip_count <= 0
	$BottomContainer/BottomHorizontalContainer/StepBackButton.disabled = stage != GameArea.Stage.VIEW_RESULT or step_number <= 0
	$BottomContainer/BottomHorizontalContainer/CheckButton.disabled = stage == GameArea.Stage.CHECK or step_number > 0 or alive_count != alive_max_count or step_number != 0
	$BottomContainer/BottomHorizontalContainer/ResetButton.disabled = stage == GameArea.Stage.CHECK or step_number > 0
	$BottomContainer/BottomHorizontalContainer/StepButton.disabled = stage != GameArea.Stage.VIEW_RESULT or step_number >= step_count


func _on_level_complete():
	$LevelCompletePopup.popup_centered()
