extends Node

func inst_on_main_scene(object):
	var main_scene = get_tree().current_scene;
	main_scene.call_deferred("add_child", object)
	return object
	
func remap_range(value, InputA, InputB, OutputA, OutputB):
	var result = (value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
	return result
