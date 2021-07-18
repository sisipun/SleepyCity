extends TextureButton


func _ready() -> void:
	if TipController.count() <= 0:
		disabled = true


func _on_pressed() -> void:
	if TipController.count() <= 0:
		disabled = true
