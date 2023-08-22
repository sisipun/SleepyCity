class_name LevelFailedPopup
extends Control


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)


func _ready() -> void:
	EventStorage.level_failed.connect(_on_level_failed)


func _on_level_failed() -> void:
	show()
	EventStorage.emit_signal("popup_open")
	_animation_player.play("popup")


func _on_reset_pressed() -> void:
	hide()
	EventStorage.emit_signal("popup_close")
	EventStorage.emit_signal("reset_request")
