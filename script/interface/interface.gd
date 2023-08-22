class_name Interface
extends Control


# TODO back later
#@export_node_path("AnimationButton") var _skip_button_path: NodePath
#
#@onready var _skip_button: AnimationButton = get_node(_skip_button_path)


func _ready() -> void:
	EventStorage.popup_open.connect(_on_popup_open)
	EventStorage.popup_close.connect(_on_popup_close)
	# TODO back later
	#if false and OS.get_name() != "Windows": #TODO remove after release to show ads
	#	_skip_button.disabled = true
	#	MobileAds.initialization_complete.connect(_on_ads_initialization_complete)
	#	MobileAds.rewarded_ad_loaded.connect(_on_ads_rewarded_ad_loaded)
	#	MobileAds.rewarded_ad_closed.connect(_on_ads_rewarded_ad_closed)


func _on_popup_open() -> void:
	hide()


func _on_popup_close() -> void:
	show()


# TODO back later
#func _on_ads_initialization_complete(status, _adapter_name) -> void:
#	if status == MobileAds.INITIALIZATION_STATUS.READY:
#		MobileAds.load_rewarded()


# TODO back later
#func _on_ads_rewarded_ad_loaded() -> void:
#	_skip_button.disabled = false


# TODO back later
#func _on_ads_rewarded_ad_closed() -> void:
#	EventStorage.emit_signal("level_complete_request", 0, true)
#	_skip_button.disabled = true
#	MobileAds.load_rewarded()


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset_request")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	# TODO back later
	#if false and OS.get_name() != "Windows": #TODO remove after release to show ads
	#	MobileAds.show_rewarded()
	#	MobileAds.load_rewarded()
	#else:
	EventStorage.emit_signal("level_complete_request", 0, true)
