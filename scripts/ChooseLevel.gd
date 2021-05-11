extends Control

func _ready():
	for i in len(Game.levels()):
		var button = Button.new()
		var level = Game.levels()[i]
		button.disabled = not level.opened
		button.text = "Level %d" % [i + 1]
		button.connect("pressed", self, "_on_Level_clicked", [i])
		$ButtonsScroll/Buttons.add_child(button)

func _on_Level_clicked(i):
	Game.currentLevelIndex = i
	get_tree().change_scene("res://scenes/Level.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
