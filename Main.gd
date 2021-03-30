extends Node2D

export (PackedScene) var Cell
export var width = 30
export var height = 15

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	var cell_width = screen_size.x / width
	var cell_height = screen_size.y / height
	
	for i in range(width):
		for j in range(height):
			var cell = Cell.instance()
			add_child(cell)
			if randi() % 2:
				cell.set_alive(false)
			cell.set_size(Vector2(cell_width, cell_height))
			cell.position = Vector2(cell_width / 2 + i * cell_width, cell_height / 2 + j * cell_height)