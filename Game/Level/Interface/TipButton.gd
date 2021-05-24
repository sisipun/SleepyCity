extends Button


func _ready() -> void:
	if Game.tip_count() <= 0:
		disabled = true
	text = "Tip (%d)" % Game.tip_count()


func _on_pressed() -> void:
	if Game.tip_count() <= 0:
		disabled = true
	text = "Tip (%d)" % Game.tip_count()
