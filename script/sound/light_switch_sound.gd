class_name LightSwitchSound
extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.steped.connect(_on_steped)
	EventStorage.steped_back.connect(_on_steped)
	EventStorage.reseted.connect(_on_steped)


func _on_steped(_step_number: int, _attempts_left: int) -> void:
	play()
