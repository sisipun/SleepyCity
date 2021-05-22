extends Button


func _ready() -> void:
	text = "Tip (%d)" % Game.tip_count()


func _on_pressed() -> void:
	text = "Tip (%d)" % Game.tip_count()
