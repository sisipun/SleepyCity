class_name Interface
extends Control


@export_node_path("AnimationButton") var _skip_button_path: NodePath

@onready var _skip_button: AnimationButton = get_node(_skip_button_path)


func _ready() -> void:
	_skip_button.disabled = true
	
	EventStorage.popup_open.connect(_on_popup_open)
	EventStorage.popup_close.connect(_on_popup_close)
	
	EventStorage.ad_initialized.connect(_on_ad_initialized)
	EventStorage.interstitial_ad_closed.connect(_on_interstitial_ad_closed)
	EventStorage.rewarded_ad_loaded.connect(_on_rewarded_ad_loaded)
	EventStorage.rewarded_ad_earned.connect(_on_rewarded_ad_earned)
	EventStorage.rewarded_ad_closed.connect(_on_rewarded_ad_closed)


func _on_popup_open() -> void:
	hide()


func _on_popup_close() -> void:
	show()


func _on_ad_initialized() -> void:
	EventStorage.emit_signal("banner_ad_load_request")
	EventStorage.emit_signal("interstitial_ad_load_request")
	EventStorage.emit_signal("rewarded_ad_load_request")


func _on_reset_pressed() -> void:
	EventStorage.emit_signal("reset_request")


func _on_menu_pressed() -> void:
	EventStorage.emit_signal("menu_open")


func _on_skip_pressed() -> void:
	EventStorage.emit_signal("rewarded_ad_show_request")


func _on_interstitial_ad_closed() -> void:
	EventStorage.emit_signal("interstitial_ad_load_request")


func _on_rewarded_ad_loaded() -> void:
	_skip_button.disabled = false


func _on_rewarded_ad_earned() -> void:
	EventStorage.emit_signal("level_complete_request", 0, true)
	_skip_button.disabled = true
	EventStorage.emit_signal("rewarded_ad_load_request")


func _on_rewarded_ad_closed() -> void:
	EventStorage.emit_signal("rewarded_ad_load_request")
