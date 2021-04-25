extends Node2D

onready var tween = $Tween
onready var player = $Player

func _input(event):
	if event.is_action_pressed("ui_accept"):
		start_player_tween()

func start_player_tween():
	player.velocity = Vector2.ZERO
	player.activated = false
	tween.interpolate_property(player, 'position', player.position, Vector2(80, 30), 
		3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
