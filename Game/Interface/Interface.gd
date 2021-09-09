extends Control


class_name Interface


func _ready() -> void:
	MobileAds.connect("initialization_complete", self, "_on_ads_initialization_complete")
	MobileAds.connect("rewarded_ad_closed", self, "_on_ads_rewarded_ad_closed")


func _on_ads_initialization_complete(status, _adapter_name) -> void:
	if status == MobileAds.INITIALIZATION_STATUS.READY:
		MobileAds.load_rewarded()


func _on_ads_rewarded_ad_closed() -> void:
	MobileAds.load_rewarded()


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset")


func _on_step_back_pressed() -> void:
	EventStorage.emit_signal("step_back")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	MobileAds.show_rewarded()
	MobileAds.load_rewarded()
	EventStorage.emit_signal("complete_current_level")


func _on_tutorial_pressed() -> void:
	EventStorage.emit_signal("tutorial_open")
