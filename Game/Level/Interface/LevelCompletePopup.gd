extends Popup


signal back_to_menu
signal next


func _ready() -> void:
	Game.connect("level_complete", self, "_on_level_complete")


func _on_level_complete(level: Game.LevelInfo, step_count: int, earn_bonus: bool, is_last_level: bool, is_last_pack: bool) -> void:
	popup_centered()
	var step = level.step_count
	$Menu/CenterLabels/Labels/StepLabel.text = "%d/%d" % [step_count, len(level.solution)]
	
	if is_last_level:
		$Menu/Buttons/NextButton.hide()
	else:
		$Menu/Buttons/NextButton.show()
	
	if earn_bonus:
		$Menu/CenterLabels/Labels/BonusTexture.show()
	else:
		$Menu/CenterLabels/Labels/BonusTexture.hide()


func _on_menu_pressed() -> void:
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")


func _on_next_pressed() -> void:
	get_tree().change_scene("res://Game/Level/Level.tscn")
