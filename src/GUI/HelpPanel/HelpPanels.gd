extends Control

onready var tween : Tween = $Transition
onready var next_button = $Next
onready var before_button = $Before
onready var panels = $Panels
onready var  easy_arrow = $Panels/Option/Easy/Arrow
onready var  hard_arrow = $Panels/Option/Hard/Arrow

const panel_list = ["credits", "options", "goal", "controls", "obstacles", "powerups"]
var index = 2

const button_sound = preload("res://assets/sounds/br_bouton.wav")

export (String) var actual_panel = "goal" setget set_actual_panel


func _ready():
	$Panels/Option/Music_Slider.value = MusicManager.music_level
	$Panels/Option/Sound_Slider.value = MusicManager.sound_level

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
#		$Before/Label.text = panel_list[index-1]
	elif self.index == 0:
		#premier element
		before_button.visible = false
#		$Next/Label.text = panel_list[index+1]
	else:
		next_button.visible = true
#		$Next/Label.text = panel_list[index+1]
		before_button.visible = true
#		$Before/Label.text = panel_list[index-1]
		


func _on_Music_Slider_value_changed(value):
	MusicManager.music_level = value


func _on_Sound_Slider_value_changed(value):
	MusicManager.sound_level = value
	MusicManager.play_sound(button_sound)


func _on_Hard_pressed():
	Global.difficulty_mode = "hard"
	easy_arrow.visible = false
	hard_arrow.visible = true


func _on_Easy_pressed():
	Global.difficulty_mode = "easy"
	easy_arrow.visible = true
	hard_arrow.visible = false
	
