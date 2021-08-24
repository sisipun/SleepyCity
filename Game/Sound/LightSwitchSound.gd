extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("step", self, "_on_step")


func _on_step(_step_count: int) -> void:
	play()
