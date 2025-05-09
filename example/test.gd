extends Node2D

# - update clas and lib names (com.example.mylibrary GodotAndroidPlugin)
# 	- care! dirst make commit in both godot and adroid studio
# - check cloud improvement suggestions
# - update test scene
# - update readme
# - update notes in notion

func _onInternetConnectionStateChange(state: bool):
	$Label.text = str(state)
	$HistoryLabel.text += str(state) + "\n"


func _on_button_pressed() -> void:
	$Label.text = str(AndroidNetworkStateNode.hasNetwork())


func _on_reset_button_pressed() -> void:
	$Label.text = ""
	$HistoryLabel.text = ""


func _on_subscribe_button_pressed() -> void:
	if AndroidNetworkStateNode.stateChanged.is_connected(_onInternetConnectionStateChange):
		return
	AndroidNetworkStateNode.stateChanged.connect(_onInternetConnectionStateChange)
	$SubscriptionState.text = "true"

func _on_unsubscribe_button_pressed() -> void:
	if not AndroidNetworkStateNode.stateChanged.is_connected(_onInternetConnectionStateChange):
		return
	AndroidNetworkStateNode.stateChanged.disconnect(_onInternetConnectionStateChange)
	$SubscriptionState.text = "false"
