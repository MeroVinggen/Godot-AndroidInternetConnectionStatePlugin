extends Node
class_name AndroidNetworkState

signal stateChanged(curState: bool)

const _pluginName = "AndroidInternetConnectionStatePlugin"
var _pluginObj: Object


func _ready() -> void:
	if OS.get_name() == "Android":
		if Engine.has_singleton(_pluginName):
			_pluginObj = Engine.get_singleton(_pluginName)
			_initialize()
		else:
			printerr("AndroidInternetConnectionStatePlugin is not available on this Android device")
	else:
		printerr("AndroidInternetConnectionStatePlugin is available only at Android platform")


func _initialize() -> void:
	# forward signals
	_pluginObj.stateChanged.connect(func(state: String) -> void: stateChanged.emit(state == "true"))


func hasNetwork() -> bool:
	if _pluginObj:
		return bool(_pluginObj.isNetworkConnected())
	return false
