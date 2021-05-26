extends VBoxContainer

func _ready() -> void:
	for i in len(Game.packs()):
		var pack: Button = Button.new()
		pack.text = "%d" % i
		pack.disabled = not Game.packs()[i].opened
		pack.connect("pressed", self, "_on_level_clicked", [i])
		add_child(pack)


func _on_level_clicked(i: int) -> void:
	Game.set_current_pack(i)
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")
