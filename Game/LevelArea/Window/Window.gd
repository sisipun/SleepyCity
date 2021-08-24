extends Area2D


class_name Window


signal clicked(window)


export (NodePath) onready var _shape = get_node(_shape) as CollisionShape2D
export (NodePath) onready var _body = get_node(_body) as AnimatedSprite
export (NodePath) onready var _border = get_node(_border) as Sprite
export (NodePath) onready var _tip = get_node(_tip) as Sprite
export (NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer
export (NodePath) onready var _ligth = get_node(_ligth) as Light2D


var _on: bool = false
var _target: bool = false
var _coord_x: int = 0
var _coord_y: int = 0


func _ready() -> void:
	EventStorage.connect("reset", self, "_on_reset")
	EventStorage.connect("step", self, "_on_step")
	EventStorage.connect("step_back", self, "_on_step_back")


func init(
	coord_x: int, 
	coord_y: int, 
	position: Vector2, 
	size: Vector2, 
	on: bool,
	target: bool,
	sprite_frames: SpriteFrames,
	border_sprite_texture: Texture
) -> Window:
	self.position = position
	_target = target
	_coord_x = coord_x
	_coord_y = coord_y
	set_on(on)
	scale = Vector2(
		size.x / (_shape.shape.extents.x * 2), 
		size.y / (_shape.shape.extents.y * 2)
	)
	
	_body.frames = sprite_frames
	_border.texture = border_sprite_texture
	
	_body.play()
	return self


func _on_reset() -> void:
	stop_tip_effect()


func _on_step(_step_count: int) -> void:
	stop_tip_effect()


func _on_step_back() -> void:
	stop_tip_effect()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", self)


func play_tip_effect():
	_animation_player.play("tip")
	_tip.show()


func stop_tip_effect():
	_animation_player.stop()
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
