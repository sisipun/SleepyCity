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
	var sprite_size: Vector2 = _body.frames.get_frame(_body.animation, 0).get_size()
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


func _on_reset():
	stop_tip_effect()


func _on_step(step_count: int):
	stop_tip_effect()


func _on_step_back():
	stop_tip_effect()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", self)


func play_tip_effect() -> bool:
	if _animation_player.is_playing() and _animation_player.current_animation == "tip":
		return false
	
	_animation_player.play("tip")
	_tip.show()
	return true


func stop_tip_effect() -> bool:
	if not _animation_player.is_playing() or _animation_player.current_animation != "tip":
		return false
	
	_animation_player.stop()
	_tip.hide()
	return true


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
