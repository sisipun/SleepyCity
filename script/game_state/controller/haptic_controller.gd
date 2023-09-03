class_name HapticController
extends Node


var haptic = null


func _ready() -> void:
	if Engine.has_singleton("Haptic"):
		haptic = Engine.get_singleton("Haptic")
		EventStorage.haptic_selection_request.connect(_on_haptic_selection_request)
		EventStorage.haptic_impact_request.connect(_on_haptic_impact_request)


func _on_haptic_selection_request() -> void:
	haptic.selection()


func _on_haptic_impact_request(value: int) -> void:
	haptic.impact(value)
