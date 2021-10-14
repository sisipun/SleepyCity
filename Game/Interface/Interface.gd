extends Control


class_name Interface


export (NodePath) onready var _skip_button = get_node(_skip_button) as AnimatedButton


func _ready() -> void:
	EventStorage.connect("popup_open", self, "_on_popup_open")
	EventStorage.connect("popup_close", self, "_on_popup_close")
	if OS.get_name() != "Windows":
		_skip_button.disabled = true
		MobileAds.connect("initialization_complete", self, "_on_ads_initialization_complete")
		MobileAds.connect("rewarded_ad_loaded", self, "_on_ads_rewarded_ad_loaded")
		MobileAds.connect("rewarded_ad_closed", self, "_on_ads_rewarded_ad_closed")


func _on_popup_open() -> void:
	hide()


func _on_popup_close() -> void:
	show()


func _on_ads_initialization_complete(status, _adapter_name) -> void:
	if status == MobileAds.INITIALIZATION_STATUS.READY:
		MobileAds.load_rewarded()


func _on_ads_rewarded_ad_loaded() -> void:
	_skip_button.disabled = false


func _on_ads_rewarded_ad_closed() -> void:
	EventStorage.emit_signal("level_complete_request", 0, true)
	_skip_button.disabled = true
	MobileAds.load_rewarded()


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset_request")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	if OS.get_name() == "Windows":
		EventStorage.emit_signal("level_complete_request", 0, true)
	else:
		MobileAds.show_rewarded()
		MobileAds.load_rewarded()
