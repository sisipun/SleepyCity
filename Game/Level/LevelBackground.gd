extends NinePatchRect


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(level: LevelInfo, levelResource: LevelResource, progress: int) -> void:
	texture = levelResource.background_texture
