extends Node2D

onready var animation = $AnimationPlayer
onready var powerup_sprite = $"GUI/HUD-Power-up/ActualPower"

func _ready():
	Global.connect("get_item", self, "_on_Player_get_item")


func _on_HUDPlay_pressed():
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

func _on_HUDHelp_pressed():
	print("Menu Help")


func _on_HUDCredit_pressed():
	print("Menu Credits")
