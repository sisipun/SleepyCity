extends Control

func _ready():
	for i in len(Levels.values):
		var button = Button.new()
		var level = Levels.values[i]
		button.disabled = not level.opened
		button.text = "Level %d (%d)" % [i + 1, level.attempt_count]  if level.attempt_count > 0 else "Level %d" % (i + 1)
		button.connect("pressed", self, "_on_Level_clicked", [i])
		$ButtonsScroll/Buttons.add_child(button)

func _on_Level_clicked(i):
	Levels.currentIndex = i
	get_tree().change_scene("res://scenes/Level.tscn")
