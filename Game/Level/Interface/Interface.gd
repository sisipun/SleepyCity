extends Control

signal reset
signal tip
signal back_to_menu
signal next

func _ready() -> void:
	$Top/Labels/StepLabel.text = "0"
	$Bottom/Buttons/TipButton.text = "Tip (%d)" % Game.tip_count()


func _on_step(step_count: int) -> void:
	$Top/Labels/StepLabel.text = "%d" % step_count


func _on_tip_pressed() -> void:
	emit_signal("tip")
	$Bottom/BottomButtons/TipButton.text = "Tip (%d)" % Game.tip_count()	


func _on_reset_pressed() -> void:
	emit_signal("reset")
	$Top/TopLabels/StepLabel.text = "0"


func _on_back_pressed() -> void:
	emit_signal("back_to_menu")


func _on_menu() -> void:
	emit_signal("back_to_menu")


func _on_next() -> void:
	emit_signal("next")
