extends Node2D

onready var animation = $AnimationPlayer
onready var powerup_sprite = $"GUI/HUD-Power-up/ActualPower"
onready var color_rect = $ColorRect
onready var player_tween = $PlayerTween
onready var color_tween = $ColorTween

const item_looted = preload("res://assets/sounds/br_powerup_ramasser.wav")
const play_button = preload("res://assets/sounds/br_play.wav")

var base_color = Color("#a1a1a5")
var end_color = Color("#3e3e52")

signal goal_achieved

var score = 0 setget set_score

func _ready():
	Global.connect("get_item", self, "_on_Player_get_item")
	MusicManager.play_music('menu')

func _on_HUDPlay_pressed():
	MusicManager.play_sound(play_button)
	MusicManager.stop_music(0.5)
	animation.play("startGame")
	color_tween_in()
	

func color_tween_in():
	color_tween.stop_all()
	color_tween.interpolate_property(color_rect, 'color', base_color, end_color, 170)
	color_tween.start()

func color_tween_out():
	color_tween.stop_all()
	color_tween.interpolate_property(color_rect, 'color', color_rect.color, base_color, 1)
	color_tween.start()

func _on_Player_get_item(item_name):
	if item_name == "":
		powerup_sprite.visible = false
	else:
		MusicManager.play_sound(item_looted)
		powerup_sprite.visible = true
		match(item_name):
			"shock":
				powerup_sprite.frame = 1
			"shield":
				powerup_sprite.frame = 0
			"dash":
				powerup_sprite.frame = 2


func _on_ScoreTimer_timeout():
	self.score += 1

func set_score(new_value):
	score = new_value
	$"GUI/HUD-Score/Score".text = "Depth : " + str(score)
	if score >= 1000:
		$ScoreTimer.stop()
		animation.play("endgame")


func _on_Player_player_dead():
	self.reset()
	color_tween_out()
	$ObstacleGenerator.stop()
	animation.play("death")
	
func reset():
	self.score = 0
	$ScoreTimer.stop()

func start_player_tween():
	MusicManager.change_music("abyss", 3)
	$Player.activated = false
	$Player.velocity = Vector2.ZERO
	player_tween.interpolate_property($Player, 'position', $Player.position, Vector2(80, 30), 
		3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	player_tween.start()
	yield(player_tween, "tween_all_completed")
	player_tween.interpolate_property($Player, 'position', $Player.position, Vector2(80, 234), 
		12, Tween.TRANS_LINEAR, Tween.EASE_IN)
	player_tween.start()
	yield(player_tween, "tween_all_completed")
	MusicManager.stop_music(0.2)

func launch_intro_music():
	MusicManager.play_music('intro')


func _on_VideoPlayer_finished():
	get_tree().quit()
