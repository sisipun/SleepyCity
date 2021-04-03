extends Area2D

signal clicked(coord_x, coord_y)
export var alive = true

var alive_texture = preload("res://alive_cell.png")
var dead_texture = preload("res://dead_cell.png")
var coord_x = 0
var coord_y = 0

func init(coord_x, coord_y, alive, position, size):
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_alive(alive)
	var current_size = $Sprite.texture.get_size()
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / current_size.x, size.y / current_size.y)
	return self

func _ready():
	set_alive(alive)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", self.coord_x, self.coord_y)

func set_alive(alive):
	self.alive = alive
	if self.alive:
		$Sprite.set_texture(alive_texture)
	else:
		$Sprite.set_texture(dead_texture)
