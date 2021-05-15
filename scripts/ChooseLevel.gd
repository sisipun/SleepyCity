extends Control

func _ready():
	var preview_scene = load("res://scenes/LevelPreview.tscn")
	var horizontal_container
	for i in len(Game.levels()):
		if i % 2 == 0:
			horizontal_container = HBoxContainer.new()
			$ButtonsScroll/Buttons.add_child(horizontal_container)
		var preview = preview_scene.instance().init(i)
		preview.size_flags_horizontal = 3
		preview.size_flags_vertical = 3
		preview.connect("clicked", self, "_on_level_clicked")
		horizontal_container.add_child(preview)

func _on_level_clicked(i):
	Game.currentLevelIndex = i
	get_tree().change_scene("res://scenes/Level.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
