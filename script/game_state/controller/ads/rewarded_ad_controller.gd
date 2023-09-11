class_name RewardedAdController
extends Node


@export var _android_ad_unit: String
@export var _ios_ad_unit: String
@export var _enabled: bool

var _ad_unit: String
var _ad: RewardedAd
var _ad_load_callback: RewardedAdLoadCallback = RewardedAdLoadCallback.new()
var _ad_shown_callback: OnUserEarnedRewardListener = OnUserEarnedRewardListener.new()
var _ad_full_screen_content_callback: FullScreenContentCallback = FullScreenContentCallback.new()

func _ready() -> void:
	if _enabled:
		_ad_unit = get_ad_unit()
		EventStorage.rewarded_ad_load_request.connect(_on_ad_load_request)
		EventStorage.rewarded_ad_show_request.connect(_on_ad_show_request)
	
	_ad_load_callback.on_ad_loaded = _on_ad_loaded
	_ad_load_callback.on_ad_failed_to_load = _on_ad_failed_to_load
	
	_ad_shown_callback.on_user_earned_reward = _on_ad_earned
	
	_ad_full_screen_content_callback.on_ad_dismissed_full_screen_content = _on_ad_closed
	_ad_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = _on_ad_failed_to_show


func get_ad_unit() -> String:
	if OS.get_name() == "Android":
		return _android_ad_unit
	elif OS.get_name() == "iOS":
		return _ios_ad_unit
	else:
		return ""


func _on_ad_load_request() -> void:
	RewardedAdLoader.new().load(_ad_unit, AdRequest.new(), _ad_load_callback)


func _on_ad_loaded(ad: RewardedAd) -> void:
	if _ad:
		_ad.destroy()
	
	self._ad = ad
	self._ad.full_screen_content_callback = _ad_full_screen_content_callback
	EventStorage.emit_signal("rewarded_ad_loaded")


func _on_ad_failed_to_load(error: LoadAdError) -> void:
	print(error.message)


func _on_ad_show_request() -> void:
	if _ad:
		_ad.show(_ad_shown_callback)


func _on_ad_earned(_item: RewardedItem) -> void:
	EventStorage.emit_signal("rewarded_ad_earned")


func _on_ad_closed() -> void:
	EventStorage.emit_signal("rewarded_ad_closed")


func _on_ad_failed_to_show(_adError: AdError) -> void:
	EventStorage.emit_signal("rewarded_ad_closed")
