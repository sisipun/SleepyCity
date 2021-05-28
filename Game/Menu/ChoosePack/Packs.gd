extends VBoxContainer


func _ready() -> void:
	var pack_preview_scene: = load("res://Game/Menu/ChoosePack/PackPreview.tscn")
	for i in range(Game.packs().size()):
		var preview: PackPreview = pack_preview_scene.instance().init(i)
		preview.connect("clicked", self, "_on_pack_clicked")
		add_child(preview)


func _on_pack_clicked(i: int) -> void:
	Game.set_current_pack(i)
	get_tree().change_scene("res://Game/Menu/ChooseLevel/ChooseLevel.tscn")
