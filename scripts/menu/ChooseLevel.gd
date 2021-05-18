extends VBoxContainer


func _ready() -> void:
	var preview_scene: = load("res://scenes/menu/LevelPreview.tscn")
	for i in len(Game.levels()):
		var preview: LevelPreview = preview_scene.instance().init(i)
		preview.connect("clicked", self, "_on_level_clicked")
		$ButtonsScroll/ButtonsMargin/Buttons.add_child(preview)


func _on_level_clicked(i: int) -> void:
	Game.set_current_level(i)
	get_tree().change_scene("res://scenes/level/Level.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
