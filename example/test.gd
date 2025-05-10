extends MarginContainer

@onready var stateValueLabel: Label = $VBoxContainer/HBoxContainer/StateValueLabel
@onready var subscriptionState: Label = $VBoxContainer/HBoxContainer3/SubscriptionState

var _isSubscribed: bool = false

# - update readme
# - upload changes to github and assets lib
# - update notes in notion

func updateInternetConnectionState(state: bool = AndroidNetworkStateNode.hasNetwork()):
	stateValueLabel.text = str(state)


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
