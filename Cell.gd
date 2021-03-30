extends Node2D

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
	$Sprite.scale = Vector2(size.x / current_size.x, size.y / current_size.y)