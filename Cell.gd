extends Area2D

class_name Cell

enum Type { ALIVE, DEAD, TARGET }

signal clicked(coord_x, coord_y)

export var type = Type.DEAD

var alive_texture = preload("res://alive_cell.png")
var dead_texture = preload("res://dead_cell.png")
var target_texture = preload("res://target_cell.png")
var coord_x = 0
var coord_y = 0

func init(coord_x, coord_y, position, size, alpha = 1, type = Type.DEAD):
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_type(type)
	var current_size = $Sprite.texture.get_size()
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / current_size.x, size.y / current_size.y)
	$Sprite.modulate.a = alpha
	return self

func _ready():
	set_type(type)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", coord_x, coord_y)

func set_type(type):
	self.type = type
	if self.type == Type.ALIVE:
		$Sprite.set_texture(alive_texture)
	elif self.type == Type.DEAD:
		$Sprite.set_texture(dead_texture)
	elif self.type == Type.TARGET:
		$Sprite.set_texture(target_texture)
		
func is_alive():
	return type == Type.ALIVE
	
func set_alive(alive):
	if alive:
		type = Type.ALIVE
	else:
		type = Type.DEAD
	set_type(type)
