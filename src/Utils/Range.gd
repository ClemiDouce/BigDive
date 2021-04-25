tool
extends Node2D
class_name RangePos

onready var pos_begin := $Begin
onready var pos_end := $End

var start
var end

export (Color) var line_color
export (int) var width

func _ready():
	start = pos_begin.global_position
	end = pos_end.global_position

func _process(_delta):
	if Engine.editor_hint:
		update()

func _draw():
	draw_line($Begin.global_position, $End.global_position, line_color, width)
