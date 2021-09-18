extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("step", self, "_on_step")


func _on_step(_step_number: int, _attempts_left: int) -> void:
	play()
