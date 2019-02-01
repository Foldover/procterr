tool
extends EditorPlugin

func _enter_tree():
    # Initialization of the plugin goes here
	print("Init terrain")
	add_custom_type("Terrain", "Node", preload("terrain.gd"), preload("processors/default.png"))
	add_custom_type("Perlin", "Resource", preload("processors/perlin.gd"), preload("processors/default.png"))

func _exit_tree():
    # Clean-up of the plugin goes here
	remove_custom_type("Perlin")
	