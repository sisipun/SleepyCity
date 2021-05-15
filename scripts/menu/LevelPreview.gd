extends MarginContainer

signal clicked(index)

var level_index = 0

func init(index):
	level_index = index
	var level = Game.levels()[level_index]
	$LevelButton.disabled = not level.opened
	$LevelButton.text = "%d*" % [level_index + 1] if level.bonus else "%d" % [level_index + 1] 
	return self

func _on_level_pressed():
	emit_signal("clicked", level_index)
