extends Control

onready var tween : Tween = $Transition
onready var next_button = $Next
onready var before_button = $Before
onready var panels = $Panels

const panel_list = ["option", "goal", "controls", "obstacle", "powerup"]
var index = 1

const button_sound = preload("res://assets/sounds/br_bouton.wav")

export (String) var actual_panel = "goal" setget set_actual_panel


func move_panels(dir: String):
	var goal_pos := Vector2()
	if dir=="left":
		goal_pos = Vector2(panels.position.x + 162,panels.position.y)
	elif dir=="right":
		goal_pos = Vector2(panels.position.x - 162,panels.position.y)
	tween.interpolate_property(panels, 'position', panels.position, goal_pos, 0.5)		
	tween.start()

func _on_Next_pressed():
	if not tween.is_active():
		MusicManager.play_sound(button_sound)
		index += 1
		self.actual_panel = panel_list[index]
		move_panels("right")

func _on_Before_pressed():
	if not tween.is_active():
		MusicManager.play_sound(button_sound)
		index -= 1
		self.actual_panel = panel_list[index]
		move_panels("left")

func set_actual_panel(new_panel):
	actual_panel = new_panel
	if self.index == panel_list.size() - 1:
		#dernier element
		next_button.visible = false
	elif self.index == 0:
		#premier element
		before_button.visible = false
	else:
		next_button.visible = true
		before_button.visible = true
		


func _on_Music_Slider_value_changed(value):
	MusicManager.music_level = value


func _on_Sound_Slider_value_changed(value):
	MusicManager.sound_level = value
