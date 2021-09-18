extends Control


class_name Interface


export (NodePath) onready var _skip_button = get_node(_skip_button) as AnimatedButton


func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		_skip_button.disabled = true
		MobileAds.connect("initialization_complete", self, "_on_ads_initialization_complete")
		MobileAds.connect("rewarded_ad_loaded", self, "_on_ads_rewarded_ad_loaded")
		MobileAds.connect("rewarded_ad_closed", self, "_on_ads_rewarded_ad_closed")


func _on_ads_initialization_complete(status, _adapter_name) -> void:
	if status == MobileAds.INITIALIZATION_STATUS.READY:
		MobileAds.load_rewarded()


func _on_ads_rewarded_ad_loaded() -> void:
	_skip_button.disabled = false


func _on_ads_rewarded_ad_closed() -> void:
	EventStorage.emit_signal("complete_current_level")
	_skip_button.disabled = true
	MobileAds.load_rewarded()


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		MobileAds.show_rewarded()
		MobileAds.load_rewarded()
	else:
		EventStorage.emit_signal("complete_current_level")
