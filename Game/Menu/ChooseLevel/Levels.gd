extends GridContainer


func _ready() -> void:
	var level_preview_scene: = load("res://Game/Menu/ChooseLevel/LevelPreview.tscn")
	for i in len(Storage.get_current_levels()):
		var preview: LevelPreview = level_preview_scene.instance().init(i)
		preview.connect("clicked", self, "_on_level_clicked")
		add_child(preview)


func _on_level_clicked(i: int) -> void:
	Storage.set_current_level(i)
	get_tree().change_scene("res://Game/Level/Story/StoryLevel.tscn")
