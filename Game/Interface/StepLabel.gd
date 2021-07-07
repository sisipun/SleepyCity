extends Label


func _ready() -> void:
	text = "0"


func _on_step(step_count) -> void:
	text = "%d" % step_count


func _on_reset() -> void:
	text = "0"
