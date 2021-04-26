extends Node

# warning-ignore:unused_signal
signal get_item(item_name)
# warning-ignore:unused_signal
signal difficulty_level_changed(new_level)

var difficulty_mode = "hard" setget set_difficulty_mode

func set_difficulty_mode(new_value):
	difficulty_mode = new_value
	print(difficulty_mode)
