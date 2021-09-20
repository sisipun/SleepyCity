extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.connect("steped", self, "_on_steped")
	EventStorage.connect("steped_back", self, "_on_steped")
	EventStorage.connect("reseted", self, "_on_steped")	


func _on_steped(_step_number: int, _attempts_left: int) -> void:
	play()
