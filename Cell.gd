extends Area2D

export var alive = true

var alive_texture = preload("res://alive_cell.png")
var dead_texture = preload("res://dead_cell.png")

func _ready():
	set_alive(alive)
		
func set_alive(new_alive):
	alive = new_alive
	if alive:
		$Sprite.set_texture(alive_texture)
	else:
		$Sprite.set_texture(dead_texture)

func set_size(size):
	var current_size = $Sprite.texture.get_size()
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / current_size.x, size.y / current_size.y)

func _on_Cell_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
        set_alive(!alive)
