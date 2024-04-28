extends Node2D

var _InternetConnectionStatePlugin

func _ready():
	if OS.get_name() == "Android":
		if Engine.has_singleton("InternetConnectionStatePlugin"):
			_InternetConnectionStatePlugin = Engine.get_singleton("InternetConnectionStatePlugin")
		else:
			printerr("InternetConnectionStatePlugin is not available on this Android device")
	else:
		printerr("InternetConnectionStatePlugin is available only at Android platform")


func _onInternetStateChange(data):
	$Label.text = str(data)
	$HistoryLabel.text += str(data) + "\n"


func _on_button_pressed() -> void:
	$Label.text = str(_InternetConnectionStatePlugin.isNetworkConnected())


func _on_reset_button_pressed() -> void:
	$Label.text = ""
	$HistoryLabel.text = ""


func _on_subscribe_button_pressed() -> void:
	_InternetConnectionStatePlugin.connect("hasNetwork", _onInternetStateChange)
	$SubscriptionState.text = "true"

func _on_unsubscribe_button_pressed() -> void:
	_InternetConnectionStatePlugin.disconnect("hasNetwork", _onInternetStateChange)
	$SubscriptionState.text = "false"
