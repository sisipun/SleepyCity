extends Area2D


class_name Cell


signal clicked(cell)


export (NodePath) var _shape_path
export (NodePath) var _sprite_path
export (NodePath) var _border_path
export (NodePath) var _tip_path


onready var _shape: CollisionShape2D = get_node(_shape_path)
onready var _sprite: AnimatedSprite = get_node(_sprite_path)
onready var _border: AnimatedSprite = get_node(_border_path)
onready var _tip: AnimatedSprite = get_node(_tip_path)


var _alive: bool = false
var _target: bool = false
var _coord_x: int = 0
var _coord_y: int = 0


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		stop_tip_effect()
		emit_signal("clicked", self)


func init(
		coord_x: int, 
		coord_y: int, 
		position: Vector2, 
		size: Vector2, 
		alive: bool = false,
		target: bool = false
	) -> Cell:
	var sprite_size: Vector2 = _sprite.frames.get_frame(_sprite.animation, 0).get_size()
	self.position = position
	_target = target
	_coord_x = coord_x
	_coord_y = coord_y
	set_alive(alive)
	scale = Vector2(
		size.x / (_shape.shape.extents.x * 2), 
		size.y / (_shape.shape.extents.y * 2)
	)

	_border.animation = "target" if _target else "default"
	_border.play()	
	_sprite.play()
	return self


func play_tip_effect() -> bool:
	if _tip.is_playing():
		return false
		
	_tip.play()
	_tip.show()
	return true


func stop_tip_effect() -> bool:
	if not _tip.is_playing():
		return false
		
	_tip.stop()
	_tip.hide()
	return true


func get_coordinates() -> Vector2:
	return Vector2(_coord_x, _coord_y)


func is_alive() -> bool:
	return _alive


func set_alive(alive: bool) -> void:
	_alive = alive
	if _alive:
		_sprite.animation = "alive"
	else:
		_sprite.animation = "dead"
