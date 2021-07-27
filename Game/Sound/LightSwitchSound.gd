extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("step", self, "_on_step")


func _on_step(step_count: int) -> void:
	play()
