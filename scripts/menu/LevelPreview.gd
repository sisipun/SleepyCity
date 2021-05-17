extends MarginContainer

signal clicked(index)

var play_texture = load("res://assets/preview/play.png")
var disabled_texture = load("res://assets/preview/disabled.png")

var level_index
var disabled

func init(index):
	var level = Game.levels()[index]
	
	level_index = index
	disabled = not level.opened
	
	$PreviewArea/Bottom/LevelLabel.text = "%d" % (level_index + 1)
	if disabled:
		$PreviewArea/Bottom/LevelLabel.set_modulate(Color(1, 1, 1, 1))
		$PreviewTexture.texture = disabled_texture
	else:
		$PreviewArea/Bottom/LevelLabel.set_modulate(Color(0, 0, 0, 1))
		$PreviewTexture.texture = play_texture
	if level.bonus:
		$PreviewArea/Bottom/BonusTexture.show()
	else:
		$PreviewArea/Bottom/BonusTexture.hide()
	
	return self

func _on_gui_input(event):
	if event is InputEventScreenTouch and not disabled:
		if event.is_pressed():
			emit_signal("clicked", level_index)
