class_name ButtonSound
extends AudioStreamPlayer


func _ready() -> void:
	EventStorage.sound_switch.connect(_on_button_pressed)
	EventStorage.music_switch.connect(_on_button_pressed)
	EventStorage.decrement_tip.connect(_on_button_pressed)
	EventStorage.menu_open.connect(_on_button_pressed)
	EventStorage.menu_closed.connect(_on_button_pressed)
	EventStorage.tutorial_open.connect(_on_tutorial_button_pressed)
	EventStorage.tutorial_closed.connect(_on_button_pressed)
	EventStorage.tutorial_next.connect(_on_button_pressed)
	EventStorage.tutorial_previous.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	play()


func _on_tutorial_button_pressed(initial: bool) -> void:
	if not initial:
		play()
