class_name BannerAdController
extends Node


@export var _ad_unit: String
@export var _enabled: bool

var _ad: AdView
var _ad_listener: AdListener = AdListener.new()


func _ready() -> void:
	if _enabled:
		EventStorage.banner_ad_load_request.connect(_on_ad_load_request)
	
	_ad_listener.on_ad_loaded = _on_ad_loaded
	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load


func _on_ad_load_request() -> void:
	if _ad:
		_ad.destroy()
	
	var ad_size: AdSize = AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	_ad = AdView.new(_ad_unit, ad_size, AdPosition.Values.BOTTOM)
	
	_ad.load_ad(AdRequest.new())


func _on_ad_loaded() -> void:
	if _ad:
		_ad.show()


func _on_ad_failed_to_load(error: LoadAdError) -> void:
	print(error.message)
