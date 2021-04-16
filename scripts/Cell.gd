extends Area2D

class_name Cell

enum Type { ALIVE, DEAD, TARGET }

signal clicked(coord_x, coord_y)

const sprite_size = 1024

export var type = Type.DEAD
var coord_x = 0
var coord_y = 0

func init(coord_x, coord_y, position, size, alpha = 1, type = Type.DEAD):
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_type(type)
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$AnimatedSprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)
	$AnimatedSprite.modulate.a = alpha
	$AnimatedSprite.frame = $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) - 1
	return self

func _ready():
	$AnimatedSprite.play()
	set_type(type)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", coord_x, coord_y)

func set_type(type):
	self.type = type
	if self.type == Type.ALIVE:
		$AnimatedSprite.animation = "alive"
	elif self.type == Type.DEAD:
		$AnimatedSprite.animation = "dead"
	elif self.type == Type.TARGET:
		$AnimatedSprite.animation = "target"
		
func is_alive():
	return type == Type.ALIVE
	
func set_alive(alive):
	if alive:
		type = Type.ALIVE
	else:
		type = Type.DEAD
	set_type(type)
