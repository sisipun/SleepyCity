extends TextureButton


func _ready() -> void:
	if Storage.tip_count() <= 0:
		disabled = true


func _on_pressed() -> void:
	if Storage.tip_count() <= 0:
		disabled = true
