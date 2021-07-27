extends NinePatchRect


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(level: LevelInfo, level_resource: LevelResource, progress: int) -> void:
	texture = level_resource.background_texture
