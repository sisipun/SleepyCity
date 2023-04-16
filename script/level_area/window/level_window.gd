class_name LevelWindow
extends Area2D


signal clicked(window)


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("AnimatedSprite2D") var _body_path: NodePath
@export_node_path("Sprite2D") var _border_path: NodePath
@export_node_path("Sprite2D") var _tip_path: NodePath
@export_node_path("AnimationPlayer") var _animation_player_path: NodePath
@export_node_path("PointLight2D") var _ligth_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _body: AnimatedSprite2D = get_node(_body_path)
@onready var _border: Sprite2D = get_node(_border_path)
@onready var _tip: Sprite2D = get_node(_tip_path)
@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)
@onready var _ligth: PointLight2D = get_node(_ligth_path)


var _on: bool = false
var _target: bool = false
var _coord_x: int = 0
var _coord_y: int = 0


func _ready() -> void:
	EventStorage.steped.connect(_on_steped)
	EventStorage.steped_back.connect(_on_steped_back)
	EventStorage.reseted.connect(_on_reseted)
	EventStorage.level_changed.connect(_on_level_changed)


func init(
	coord_x: int, 
	coord_y: int, 
	_position: Vector2, 
	size: Vector2, 
	on: bool,
	target: bool,
	sprite_frames: SpriteFrames,
	border_sprite_texture: Texture2D
) -> LevelWindow:
	position = _position
	_target = target
	_coord_x = coord_x
	_coord_y = coord_y
	set_on(on)
	scale = Vector2(
		size.x / (_shape.shape.size.x), 
		size.y / (_shape.shape.size.y)
	)
	
	_body.frames = sprite_frames
	_border.texture = border_sprite_texture
	
	_body.play()
	return self


func _on_steped(_step_number: int, _attempts_left: int) -> void:
	stop_tip_effect()


func _on_steped_back(_step_number: int, _attempts_left: int) -> void:
	stop_tip_effect()


func _on_reseted(_step_number: int, _attempts_left: int) -> void:
	stop_tip_effect()


func _on_level_changed(
	_initial: bool,
	_info: LevelInfo, 
	_level_resource: LevelResource, 
	_progress: int
) -> void:
	stop_tip_effect()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", self)


func play_tip_effect() -> void:
	_animation_player.play("tip")
	_tip.show()


func stop_tip_effect() -> void:
	_animation_player.stop(true)
	_tip.hide()


func get_coordinates() -> Vector2:
	return Vector2(_coord_x, _coord_y)


func set_on(on: bool) -> void:
	_on = on
	if _on:
		_ligth.enabled = true
		_body.animation = "on"
	else:
		_ligth.enabled = false
		_body.animation = "off"
