extends MarginContainer


class_name PackPreview


signal clicked(index)


var _pack_texture: = load("res://Assets/Menu/pack.png")
var _disabled_texture: = load("res://Assets/Menu/disabled.png")
var _pack_index: int
var _disabled: bool


func init(index: int) -> PackPreview:
	var pack: Storage.PackInfo = Storage.packs()[index]
	
	_pack_index = index
	_disabled = not pack.opened
	
	$PreviewArea/PackLabel.text = "%d" % (_pack_index + 1)
	if _disabled:
		$PreviewTexture.texture = _disabled_texture
	else:
		$PreviewTexture.texture = _pack_texture
	
	return self


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not _disabled:
		if event.is_pressed():
			emit_signal("clicked", _pack_index)
