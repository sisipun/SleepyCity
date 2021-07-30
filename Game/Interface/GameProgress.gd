extends TextureProgress


class_name GameProgress


export (NodePath) onready var _left_icon = get_node(_left_icon) as NinePatchRect
export (NodePath) onready var _right_icon = get_node(_right_icon) as NinePatchRect


func _ready() -> void:
	EventStorage.connect("level_changed", self, "_on_level_changed")


func _on_level_changed(level: LevelInfo, level_resource: LevelResource, progress: int) -> void:
	value = progress
	texture_under = level_resource.game_progress_back_texture
	texture_progress = level_resource.game_progress_front_texture
	_left_icon.texture = level_resource.game_progress_left_icon_texture
	_right_icon.texture = level_resource.game_progress_right_icon_texture
