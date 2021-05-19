extends MarginContainer
class_name LevelPreview


signal clicked(index)


var _play_texture: = load("res://Assets/Menu/play.png")
var _disabled_texture: = load("res://Assets/Menu/disabled.png")
var _level_index: int
var _disabled: bool


func init(index: int) -> LevelPreview:
	var level: Game.LevelInfo = Game.levels()[index]
	
	_level_index = index
	_disabled = not level.opened
	
	$PreviewArea/Bottom/LevelLabel.text = "%d" % (_level_index + 1)
	if _disabled:
		$PreviewTexture.texture = _disabled_texture
	else:
		$PreviewTexture.texture = _play_texture
	if level.bonus:
		$PreviewArea/Bottom/BonusTexture.show()
	else:
		$PreviewArea/Bottom/BonusTexture.hide()
	
	return self


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not _disabled:
		if event.is_pressed():
			emit_signal("clicked", _level_index)
