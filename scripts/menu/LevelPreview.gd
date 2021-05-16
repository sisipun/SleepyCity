extends MarginContainer

signal clicked(index)

var play_texture = load("res://assets/preview/play.png")
var disabled_texture = load("res://assets/preview/disabled.png")

var level_index = 0

func init(index):
	level_index = index
	var level = Game.levels()[level_index]
	$PreviewArea/Bottom/LevelLabel.text = "%d" % (level_index + 1)
	
	if level.opened:
		$PreviewArea/Bottom/LevelLabel.set_modulate(Color(0, 0, 0, 1))
		$PreviewTexture.texture = play_texture
	else:
		$PreviewArea/Bottom/LevelLabel.set_modulate(Color(1, 1, 1, 1))
		$PreviewTexture.texture = disabled_texture
	
	if level.bonus:
		$PreviewArea/Bottom/BonusTexture.show()
	else:
		$PreviewArea/Bottom/BonusTexture.hide()
	
	return self

func _on_gui_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("clicked", level_index)
