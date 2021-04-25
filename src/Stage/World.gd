extends Node2D

onready var animation = $AnimationPlayer
onready var powerup_sprite = $"GUI/HUD-Power-up/ActualPower"
onready var color_rect = $ColorRect
onready var tween = $Tween

var base_color = Color("#a1a1a5")
var end_color = Color("#3e3e52")

signal goal_achieved

var score = 0 setget set_score

func _ready():
	Global.connect("get_item", self, "_on_Player_get_item")
	MusicManager.play_music('menu')

func _on_HUDPlay_pressed():
	MusicManager.stop_music(0.5)
	animation.play("startGame")

func _on_Player_get_item(item_name):
	if item_name == "":
		powerup_sprite.visible = false
	else:
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
		emit_signal("goal_achieved")
		$ScoreTimer.stop()
		animation.play("endgame")


func _on_Player_player_dead():
	self.reset()
	$ObstacleGenerator.stop()
	animation.play("death")
	
func reset():
	self.score = 0
	$ScoreTimer.stop()

func start_player_tween():
	tween.interpolate_property($Player, 'position', $Player.position, Vector2(80, 30), 
		3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func launch_intro_music():
	MusicManager.play_music('intro')
