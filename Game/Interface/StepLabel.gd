extends Label


class_name StepLabel


func _ready():
	text = "0"
	EventStorage.connect("step_count_updated", self, "_on_step_count_updated")
	EventStorage.connect("reset", self, "_on_reset")


func _on_step_count_updated(step_count) -> void:
	text = "%d" % step_count


func _on_reset() -> void:
	text = "0"
