extends MarginContainer

@onready var stateValueLabel: Label = $VBoxContainer/HBoxContainer/StateValueLabel
@onready var subscriptionState: Label = $VBoxContainer/HBoxContainer3/SubscriptionState
@onready var stateIndicator: Panel = $VBoxContainer/HBoxContainer4/StateIndicator

var _isSubscribed: bool = false


func updateInternetConnectionState(state: bool = AndroidNetworkStateNode.hasNetwork()):
	stateValueLabel.text = str(state)
	
	var styleBox: StyleBoxFlat = stateIndicator.get_theme_stylebox("panel")
	
	if state:
		styleBox.bg_color = Color.LIME
	else:
		styleBox.bg_color = Color.TOMATO
		
	stateIndicator.add_theme_stylebox_override("panel", styleBox)


func _onSubscribeButtonPressed() -> void:
	if _isSubscribed:
		return
	AndroidNetworkStateNode.stateChanged.connect(updateInternetConnectionState)
	_isSubscribed = true
	subscriptionState.text = str(_isSubscribed)


func _onUnsubscribeButtonPressed() -> void:
	if not _isSubscribed:
		return
	AndroidNetworkStateNode.stateChanged.disconnect(updateInternetConnectionState)
	_isSubscribed = false
	subscriptionState.text = str(_isSubscribed)
