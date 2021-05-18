extends CanvasLayer


func _ready() -> void:
	$Top/TopLabels/StepLabel.text = "0"
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()


func _on_step(step_count: int) -> void:
	$Top/TopLabels/StepLabel.text = "%d" % step_count


func _on_reset(reset_count: int) -> void:
	$Top/TopLabels/StepLabel.text = "0"


func _on_tip(tip_count: int) -> void:
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()


func _on_level_complete(reset_count: int) -> void:
	$LevelCompletePopup.popup_centered()
	$Bottom/BottomButtons/ResetButton.disabled = true
	$Bottom/BottomButtons/TipButton.disabled = true
