extends MarginContainer

@onready var netStateIndicator: Panel = $ScrollContainer/VBoxContainer/HBoxContainer4/StateIndicator
@onready var netStateValueLabel: Label = $ScrollContainer/VBoxContainer/HBoxContainer/HasNetStateValueLabel
@onready var hasWIFIStateValueLabel: Label = $ScrollContainer/VBoxContainer/HBoxContainer8/HasWIFIStateValueLabel
@onready var hasCellularStateValueLabel: Label = $ScrollContainer/VBoxContainer/HBoxContainer10/HasCellularStateValueLabel
@onready var netTypeValueLabel: Label = $ScrollContainer/VBoxContainer/HBoxContainer14/NetTypeValueLabel
@onready var hasEthernetStateValueLabel: Label = $ScrollContainer/VBoxContainer/HBoxContainer12/HasEthernetStateValueLabel
@onready var netStateSubscriptionState: Label = $ScrollContainer/VBoxContainer/HBoxContainer3/NetStateSubscriptionState
@onready var netTypeSubscriptionState: Label = $ScrollContainer/VBoxContainer/HBoxContainer6/NetTypeSubscriptionState

@onready var _subscriptionData: Dictionary[String, Dictionary] = {
	"netState": {
		"isSubscribed": false,
		"signalName": "stateChanged",
		"signalCallback": updateNetState,
		"subscriptionStateLabel": netStateSubscriptionState,
	},
	"netType": {
		"isSubscribed": false,
		"signalName": "networkTypeChanged",
		"signalCallback": printNetType,
		"subscriptionStateLabel": netTypeSubscriptionState,
	},
}


func updateNetState(state: bool = AndroidNetworkStateNode.hasNetwork()):
	netStateValueLabel.text = str(state)
	
	var styleBox: StyleBoxFlat = netStateIndicator.get_theme_stylebox("panel")
	
	if state:
		styleBox.bg_color = Color.LIME
	else:
		styleBox.bg_color = Color.TOMATO
		
	netStateIndicator.add_theme_stylebox_override("panel", styleBox)


func _onGetNetTypePressed() -> void:
	printNetType(str(AndroidNetworkStateNode.getActiveNetworkType()))


func _onHasWIFIPressed() -> void:
	hasWIFIStateValueLabel.text = str(AndroidNetworkStateNode.hasWIFI())


func _onHasCellularPressed() -> void:
	hasCellularStateValueLabel.text = str(AndroidNetworkStateNode.hasCellular())


func _onHasEthernetPressed() -> void:
	hasEthernetStateValueLabel.text = str(AndroidNetworkStateNode.hasEthernet())


func printNetType(netType: String) -> void:
	netTypeValueLabel.text = netType


# ---- subscriptions


func _onSubscribePressed(subscriptionKey: String) -> void:
	if _subscriptionData[subscriptionKey].isSubscribed:
		return
	AndroidNetworkStateNode[_subscriptionData[subscriptionKey].signalName].connect(_subscriptionData[subscriptionKey].signalCallback)
	_subscriptionData[subscriptionKey].isSubscribed = true
	_subscriptionData[subscriptionKey].subscriptionStateLabel.text = str(_subscriptionData[subscriptionKey].isSubscribed)


func _onUnsubscribePressed(subscriptionKey: String) -> void:
	if not _subscriptionData[subscriptionKey].isSubscribed:
		return
	AndroidNetworkStateNode[_subscriptionData[subscriptionKey].signalName].disconnect(_subscriptionData[subscriptionKey].signalCallback)
	_subscriptionData[subscriptionKey].isSubscribed = false
	_subscriptionData[subscriptionKey].subscriptionStateLabel.text = str(_subscriptionData[subscriptionKey].isSubscribed)
