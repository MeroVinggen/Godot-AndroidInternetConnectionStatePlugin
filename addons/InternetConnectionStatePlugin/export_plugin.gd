@tool
extends EditorPlugin

const _plugin_name = "InternetConnectionStatePlugin"

var export_plugin: InternetConnectionState


func _enter_tree():
	export_plugin = load("res://addons/InternetConnectionStatePlugin/InternetConnectionStatePluginClass.gd").new(_plugin_name)
	add_export_plugin(export_plugin)
	add_autoload_singleton(_plugin_name, "res://addons/InternetConnectionStatePlugin/export_plugin.gd")


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null
	remove_autoload_singleton(_plugin_name)

