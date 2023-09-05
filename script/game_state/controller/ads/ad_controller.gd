class_name AdController
extends Node


func _ready() -> void:
	var on_initialization_complete_listener: OnInitializationCompleteListener = OnInitializationCompleteListener.new()
	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
	
	var request_configuration: RequestConfiguration = RequestConfiguration.new()
	request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
	request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.TRUE
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
	request_configuration.convert_to_dictionary()
	
	MobileAds.set_request_configuration(request_configuration)
	MobileAds.initialize(on_initialization_complete_listener)


func _on_initialization_complete(_status: InitializationStatus) -> void:
	EventStorage.emit_signal("ad_initialized")
