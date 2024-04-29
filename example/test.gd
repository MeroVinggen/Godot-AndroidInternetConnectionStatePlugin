extends Node2D

var _AndroidInternetConnectionStatePlugin

func _ready():
	if OS.get_name() == "Android":
		if Engine.has_singleton("AndroidInternetConnectionStatePlugin"):
			_AndroidInternetConnectionStatePlugin = Engine.get_singleton("AndroidInternetConnectionStatePlugin")
		else:
			printerr("AndroidInternetConnectionStatePlugin is not available on this Android device")
	else:
		printerr("AndroidInternetConnectionStatePlugin is available only at Android platform")


func _onInternetConnectionStateChange(data):
	$Label.text = str(data)
	$HistoryLabel.text += str(data) + "\n"


func _on_button_pressed() -> void:
	$Label.text = str(_AndroidInternetConnectionStatePlugin.isNetworkConnected())


func _on_reset_button_pressed() -> void:
	$Label.text = ""
	$HistoryLabel.text = ""


func _on_subscribe_button_pressed() -> void:
	_AndroidInternetConnectionStatePlugin.connect("hasNetwork", _onInternetConnectionStateChange)
	$SubscriptionState.text = "true"

func _on_unsubscribe_button_pressed() -> void:
	_AndroidInternetConnectionStatePlugin.disconnect("hasNetwork", _onInternetConnectionStateChange)
	$SubscriptionState.text = "false"
