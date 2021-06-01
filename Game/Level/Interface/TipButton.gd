extends Button


func _ready() -> void:
	if Storage.tip_count() <= 0:
		disabled = true
	text = "Tip (%d)" % Storage.tip_count()


func _on_pressed() -> void:
	if Storage.tip_count() <= 0:
		disabled = true
	text = "Tip (%d)" % Storage.tip_count()
