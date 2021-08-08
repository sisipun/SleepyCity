extends Sprite


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(level: LevelInfo, level_resource: LevelResource, progress: int) -> void:
	var level_background_index = randi() % len(level_resource.level_background_textures)
	texture = level_resource.level_background_textures[level_background_index]
