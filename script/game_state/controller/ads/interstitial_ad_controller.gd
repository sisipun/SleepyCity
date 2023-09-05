class_name InterstitialAdController
extends Node


@export var _ad_unit: String
@export var _enabled: bool

var _ad: InterstitialAd
var _ad_load_callback: InterstitialAdLoadCallback = InterstitialAdLoadCallback.new()
var _ad_full_screen_content_callback: FullScreenContentCallback = FullScreenContentCallback.new()


func _ready() -> void:
	if _enabled:
		EventStorage.interstitial_ad_load_request.connect(_on_ad_load_request)
		EventStorage.interstitial_ad_show_request.connect(_on_ad_show_request)
	
	_ad_load_callback.on_ad_loaded = _on_ad_loaded
	_ad_load_callback.on_ad_failed_to_load = _on_ad_failed_to_load
	
	_ad_full_screen_content_callback.on_ad_dismissed_full_screen_content = _on_ad_closed
	_ad_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = _on_ad_failed_to_show


func _on_ad_load_request() -> void:
	InterstitialAdLoader.new().load(_ad_unit, AdRequest.new(), _ad_load_callback)


func _on_ad_loaded(ad : InterstitialAd) -> void:
	if _ad:
		_ad.destroy()
	
	self._ad = ad
	self._ad.full_screen_content_callback = _ad_full_screen_content_callback


func _on_ad_failed_to_load(error: LoadAdError) -> void:
	print(error.message)


func _on_ad_show_request() -> void:
	if _ad:
		_ad.show()


func _on_ad_closed() -> void:
	EventStorage.emit_signal("interstitial_ad_closed")


func _on_ad_failed_to_show(_adError: AdError) -> void:
	EventStorage.emit_signal("interstitial_ad_closed")
