extends Control

onready var animation = $Transition
onready var next_button = $Next
onready var before_button = $Before

const panel_list = ["option", "goal", "obstacle", "powerup"]

const button_sound = preload("res://assets/sounds/br_bouton.wav")

export (String) var actual_panel = "goal" setget set_actual_panel


func _on_Next_pressed():
	MusicManager.play_sound(button_sound)
	if actual_panel == "goal":
		animation.play("goal-obstacle")
		self.actual_panel = "obstacle"
	elif actual_panel == "obstacle":
		animation.play("obstacle-powerup")
		self.actual_panel = "powerup"		


func _on_Before_pressed():
	MusicManager.play_sound(button_sound)
	if actual_panel == "obstacle":
		animation.play("obstacle-goal")
		self.actual_panel = "goal"		
	elif actual_panel == "powerup":
		animation.play("powerup-obstacle")
		self.actual_panel = "obstacle"		

func set_actual_panel(new_panel):
	actual_panel = new_panel
	match(actual_panel):
		"goal":
			before_button.visible = false
			next_button.visible = true
		"obstacle":
			before_button.visible = true
			next_button.visible = true
		"powerup":
			before_button.visible = true
			next_button.visible = false
