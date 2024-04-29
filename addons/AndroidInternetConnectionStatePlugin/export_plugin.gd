@tool
extends EditorPlugin

const _plugin_name = "AndroidInternetConnectionStatePlugin"

var export_plugin: AndroidInternetConnectionStateClass


func _enter_tree():
	export_plugin = load("res://addons/AndroidInternetConnectionStatePlugin/AndroidInternetConnectionStateClass.gd").new(_plugin_name)
	add_export_plugin(export_plugin)
	add_autoload_singleton(_plugin_name, "res://addons/AndroidInternetConnectionStatePlugin/export_plugin.gd")


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null
	remove_autoload_singleton(_plugin_name)

