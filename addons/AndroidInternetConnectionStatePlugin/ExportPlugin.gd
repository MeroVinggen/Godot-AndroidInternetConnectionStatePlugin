@tool
extends EditorPlugin

const _pluginName = "AndroidInternetConnectionStatePlugin"
var _exportPlugin: AndroidNetworkStateExportPlugin


func _enter_tree():
	_exportPlugin = AndroidNetworkStateExportPlugin.new(_pluginName)
	add_export_plugin(_exportPlugin)


func _exit_tree():
	remove_export_plugin(_exportPlugin)
	_exportPlugin = null


class AndroidNetworkStateExportPlugin extends EditorExportPlugin:
	var _pluginName: String


	func _init(plugin_name: String):
		_pluginName = plugin_name


	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false


	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([_pluginName + "/bin/debug/" + _pluginName + "-debug.aar"])
		else:
			return PackedStringArray([_pluginName + "/bin/release/" + _pluginName + "-release.aar"])


	func _get_android_dependencies(platform, debug):
		if debug:
			return PackedStringArray([])
		else:
			return PackedStringArray([])


	func _get_name():
		return _pluginName
