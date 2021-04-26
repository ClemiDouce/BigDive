extends Node2D

onready var mouse = $Sprite
onready var inverse = $Inverse

func _process(_delta):
	mouse.position = get_global_mouse_position()
	var mouse_pos = mouse.position
	var middle = Vector2(80, 256/2)
	var window = middle * 2
	
