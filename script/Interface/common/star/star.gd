class_name Star
extends Control


@export_node_path("NinePatchRect") var _body_path: NodePath

@onready var _body: NinePatchRect = get_node(_body_path)


func set_body_alpha(alpha: float) -> void:
	_body.modulate.a = alpha
