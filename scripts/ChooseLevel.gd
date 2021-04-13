extends Control

var button_height = 300

func _ready():
	var buttons_area_rect = $ButtonsScroll/Buttons.get_global_rect()
	var buttons_area_position = buttons_area_rect.position
	var buttons_area_size = buttons_area_rect.size
	
	for i in range(Levels.values.size()):
		var button = Button.new()
		button.set_position(Vector2(buttons_area_position.x, buttons_area_position.y + (button_height * i)))
		button.set_size(Vector2(buttons_area_size.x, button_height))
		button.disabled = not Levels.values[i].opened
		button.text = "Level %d" % (i + 1)
		button.connect("pressed", self, "_on_Level_clicked", [i])
		$ButtonsScroll/Buttons.add_child(button)

func _on_Level_clicked(i):
	Levels.currentIndex = i
	get_tree().change_scene("res://scenes/Level.tscn")