extends Popup


export(String) var next_scene_path
export(String) var menu_path


func _ready() -> void:
	Storage.connect("level_complete", self, "_on_level_complete")


func _on_level_complete(level: Storage.LevelInfo, step_count: int, earn_bonus: bool, is_last_level: bool, is_last_pack: bool) -> void:
	print("popup_complete")
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
	get_tree().change_scene(menu_path)


func _on_next_pressed() -> void:
	get_tree().change_scene(next_scene_path)
