extends CanvasLayer

func _ready():
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()

func _on_tip():	
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()

func _on_level_complete(reset_count):
	$LevelCompletePopup.popup_centered()
	$Bottom/BottomButtons/ResetButton.disabled = true
	$Bottom/BottomButtons/TipButton.disabled = true
